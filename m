Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab0FMU63 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 16:58:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41703 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab0FMU62 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 16:58:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=LkI4Gxn5uLbbcB9xjithEpn0IOxsnTazAzfCUZYavmS8IARTJ+m3SEh0STzvgXjOVS
         0CSjZloCiJVQm/iRAqLE7C9nKHyLisIRTigIwmWrddUK0eRG4CvD4NjDZAQEiVvdHPas
         Gi/Pb1MqUvO85fnd1KFRiFaw+ZN2BHGRg26AE=
From: Chris Clayton <chris2553@googlemail.com>
To: =?iso-8859-1?q?Fran=E7ois_Valenduc?= 
	<francois.valenduc@tvcablenet.be>
Subject: Re: Noticeable slow-down in 2.6.35-rc3
Date: Sun, 13 Jun 2010 21:58:09 +0100
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <AANLkTimDUf0N6b5PBy2wTGeAWEIY-lUvQPHQ7D7Gyrq4@mail.gmail.com> <4C15410D.4080107@tvcablenet.be>
In-Reply-To: <4C15410D.4080107@tvcablenet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201006132158.09216.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 June 2010 21:35:25 François Valenduc wrote:
> Le 13/06/10 22:15, Chris Clayton a écrit :
<snip>
> >
> > I've bisected it and arrived at:
> >
> > 597a264b1a9c7e36d1728f677c66c5c1f7e3b837 is the first bad commit
> > commit 597a264b1a9c7e36d1728f677c66c5c1f7e3b837
> > Author: John Fastabend <john.r.fastabend@intel.com>
> > Date:   Thu Jun 3 09:30:11 2010 +0000
> >

<snip>

> This commit also makes nfsd hangs at startup on my computer (see
> https://bugzilla.kernel.org/show_bug.cgi?id=16195). This problem doesn't
> occur if it's reverted.
>

I've just found John Fastabend's easy and fast fix 
(http://marc.info/?l=linux-kernel&m=127646140827821) and am about to apply it 
and test the new kernel. back soon!

> François Valenduc



-- 
The more I see, the more I know. The more I know, the less I understand. 
Changing Man - Paul Weller
