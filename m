Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab0K3Ppk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 10:45:40 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54656 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab0K3Ppj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 10:45:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZTS/2ccvPqQF9IfuvvWXQ1rhSOTezgBgDRjRQznTINAcR1W7PZO84Y+GDgWoxO6NN9
         PKAv2JrvsLVfz+PFGvtQFeH4I69syM4toqBMaP1L9a4hj+1at7SVWDvp9pBA/spkVJ+Z
         Uz3ow3/yX5LDofEjTF8thRSQS16mbGjPRb/+o=
Date: Tue, 30 Nov 2010 23:48:55 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Sid Boyce <sboyce@blueyonder.co.uk>
Cc: LKML Mailing List <linux-kernel@vger.kernel.org>,
        opensuse factory list <opensuse-factory@opensuse.org>
Subject: Re: 2.6.37-rc3-git installed modules zero bytes long
Message-ID: <20101130154855.GA4629@hack>
References: <4CF5116B.8040204@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF5116B.8040204@blueyonder.co.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 02:59:55PM +0000, Sid Boyce wrote:
> openSUSE 11.3 on one box and openSUSE 11.4 Milestone 4 on the other.
> I have a message that says the built modules not found. When I check e.g 
> /lib/modules/2.7.37-rc3-git7-smp, most modules are zero bytes long.
> I have to "make modules_install" and use modprobe on each.
> To get the network up on the 11.3 box "modprobe r6189" then "rcnetwork  
> restart", "modprobe rtl8187", "/etc/init.d/network-remotefs start",  
> etc., etc.

Confused, shouldn't we always run 'make modules_install'?
What did you do before that?
