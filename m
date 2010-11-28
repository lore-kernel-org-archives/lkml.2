Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab0K1Nlo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 08:41:44 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44136 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab0K1Nlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 08:41:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=DHqS4mFkc3vyNTQp5/lBZ+glzUdLK7rKaq9fi4snWrhc3rppdfpy7ShVhclBp/8Olx
         HMIFeTuCVK7k71+1TaKYsOLtC3CURPZc8EnRewKGP6LmMqB1k78acuUgA1PiNHZ7od4F
         PWmfg9NqqHUt44Wv/f3DY5lNW+l5L2F3qxmoA=
Subject: Re: VT console need rewrite
From: Microcai <microcai@fedoraproject.org>
Reply-To: microcai@fedoraproject.org
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
In-Reply-To: <73BC440E-833E-4E1B-ACCC-5D68BAB89D83@mit.edu>
References: <1290941875.13526.15.camel@cai.gentoo>
	 <73BC440E-833E-4E1B-ACCC-5D68BAB89D83@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Organization: fedoraproject.org
Date: Sun, 28 Nov 2010 21:42:50 +0800
Message-ID: <1290951770.13526.18.camel@cai.gentoo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2010-11-28日的 08:24 -0500，Theodore Tso写道：
> On Nov 28, 2010, at 5:57 AM, Microcai wrote:
> 
> > Hi, there
> > 
> > 	I'm implementing the UNICODE font of the framebuffer console, (see
> > http://lkml.org/lkml/2010/11/26/50 in case you do not got my email). But
> > current vt code is too bugy, too many direct assumes about vt buffer,
> > This makes me so hard to hack.  There is TODO telling me to add UNICODE
> > support, but no room for such code, that's why my patch is so tricky.
> > 
> > 	And the code itself, if you'll excuse me, it isn't as beautiful as rest
> > of the kernel.
> > 	So, it really really need a clean rewrite.I'm ganna take is hard job.	
> > 	And, please tell me if is worth to do so.
> 
> Yes, the console is code is very old.   But please be aware that lots of code (both in the kernel and in userspace) has dependencies upon how the code behaves.   So changing it in a way that does not break backwards compatibility is hard.  i.e., it is hard to hack for a reason.
> 
> I would recommend an incremental rewrite (i.e., one patch at a time), as opposed to a rewrite from scratch.   Because people will want to be assured that things haven't broken in a horrible way as a result of a complete rewrite...
> 
> -- Ted
> 

Yeah, I'd also like to rewrite it incrementally. But... who will accept
that incrementally patch ? It just seems that incremental patch will be
horrible at the beginning...... It will be discard without a
reason .....


