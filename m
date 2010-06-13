Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab0FMVL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 17:11:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48163 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab0FMVLW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 17:11:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=ed0D1ijpbWjT8jaNOzcPhNDAoL6Nxn3Dh3kTbR5M5LVz9fJvF57iVnMQjyvAcPVmqI
         Ngaf8uYERtEgj7llOVRxPSKCYlEz5yg2O6JWq3EAML/r38+RBZSPnl981OsZC1TtrkT/
         COkyasJMxy8Ak0GDQnjjji6GPA4QsyMwogYOs=
From: Chris Clayton <chris2553@googlemail.com>
To: =?iso-8859-1?q?Fran=E7ois_Valenduc?= 
	<francois.valenduc@tvcablenet.be>
Subject: Re: Noticeable slow-down in 2.6.35-rc3
Date: Sun, 13 Jun 2010 22:11:03 +0100
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <AANLkTimDUf0N6b5PBy2wTGeAWEIY-lUvQPHQ7D7Gyrq4@mail.gmail.com> <4C15410D.4080107@tvcablenet.be> <201006132158.09216.chris2553@googlemail.com>
In-Reply-To: <201006132158.09216.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201006132211.03744.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 June 2010 21:58:09 Chris Clayton wrote:
> On Sunday 13 June 2010 21:35:25 François Valenduc wrote:
> > Le 13/06/10 22:15, Chris Clayton a écrit :
>
> <snip>
>
> > > I've bisected it and arrived at:
> > >
> > > 597a264b1a9c7e36d1728f677c66c5c1f7e3b837 is the first bad commit
> > > commit 597a264b1a9c7e36d1728f677c66c5c1f7e3b837
> > > Author: John Fastabend <john.r.fastabend@intel.com>
> > > Date:   Thu Jun 3 09:30:11 2010 +0000
>
> <snip>
>
> > This commit also makes nfsd hangs at startup on my computer (see
> > https://bugzilla.kernel.org/show_bug.cgi?id=16195). This problem doesn't
> > occur if it's reverted.
>
> I've just found John Fastabend's easy and fast fix
> (http://marc.info/?l=linux-kernel&m=127646140827821) and am about to apply
> it and test the new kernel. back soon!
>

Yes, that's fixed the problem I reported.

Thanks.

Chris

> > François Valenduc



-- 
The more I see, the more I know. The more I know, the less I understand. 
Changing Man - Paul Weller
