Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab1FZLf0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 07:35:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51471 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab1FZLe6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 07:34:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KUooenGrXXd8FffUjSL3O6OEuqwKZZ75nqDYX/oxu4qKionFE0wT7cif/nsB5RrCNP
         DNTuOd3z5NHQ0kAYuRsB6wYNG1K2W1vVsOmlt5m+32myaJzkvszeYV4Uk7ezfxx8IfV0
         KOA4y5mFR5s+/cMohPHGxVfqEUvZjPB6Am7Aw=
MIME-Version: 1.0
In-Reply-To: <1309082172.2532.31.camel@edumazet-laptop>
References: <BANLkTing9LWO6AjbdzOJzkJ9aoJhn_TLnw@mail.gmail.com>
	<1309082172.2532.31.camel@edumazet-laptop>
Date: Sun, 26 Jun 2011 13:34:57 +0200
Message-ID: <BANLkTikhGVYAFEZGS-AZf3CyS4yVN+Acvg@mail.gmail.com>
Subject: Re: 2.6.39.2 BUG: unable to handle kernel NULL pointer dereference
From: Fabio Coatti <fabio.coatti@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/26 Eric Dumazet <eric.dumazet@gmail.com>:
> Le dimanche 26 juin 2011 à 10:28 +0200, Fabio Coatti a écrit :
>> I'm trying to boot with 2.6.39.2 but the process stops somewhere in
>> network stack, with a BUG: report.
>> I've been able to capture the kernel messages usign netconsole, so be
>> patient with poor alignment :)

>
> Hi Fabio
>
> Could you test following patch :
>
> http://git2.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=6407d74c5106bb362b4087693688afd34942b094
>
>
> This should be included in 2.6.39.3, if you confirm this fixes the
> problem.
>

Yes, I can confirm that your patch fixes the problem, now running
2.6.39.2 just fine. Many thanks!



-- 
Fabio
