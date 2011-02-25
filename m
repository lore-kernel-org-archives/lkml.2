Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab1BYQjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 11:39:04 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52711 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463Ab1BYQjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 11:39:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hr7sFpTPOVW5nUItukswEc0IeN8TcWwub0MT9R6MDpE1plR9sSkcBR9TgcmDclDMIR
         MbbendijFLQ33/Xb2I+7vGQRqfX/e+mQBtMbvSjdkx2Cufl1ucEFnxFj6EaEA3MGODJH
         6OH7FN1hSgdm8z0bTF+Rb0CgsvnsE2GcuJNKM=
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
 this_cpu_cmpxchg_double
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1102251025250.4996@router.home>
References: <4D393636.4040607@cs.helsinki.fi>
	 <20110121092649.GA2832@htj.dyndns.org> <4D39A6EB.70705@zytor.com>
	 <20110121154831.GE2832@htj.dyndns.org> <20110121165425.GB11687@Krystal>
	 <20110121170847.GH2832@htj.dyndns.org>
	 <1da7491b-6e7d-4453-9c6f-0e7767421ec4@email.android.com>
	 <20110121171914.GJ2832@htj.dyndns.org> <4D3D15AF.30508@zytor.com>
	 <4D67AA06.5090200@cs.helsinki.fi> <20110225131949.GJ24828@htj.dyndns.org>
	 <alpine.DEB.2.00.1102251025250.4996@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 17:38:54 +0100
Message-ID: <1298651934.2659.88.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 25 février 2011 à 10:26 -0600, Christoph Lameter a écrit :
> On Fri, 25 Feb 2011, Tejun Heo wrote:
> 
> > > Ping? The current situation is that we're unable to merge a
> > > perfectly good SLUB performance optimization because we can't seem
> > > to agree on the this_cpu_cmpxchg_double() API.
> >
> > I thought cl was preparing new version of the patchset.  Christoph?
> 
> In order to do that I would have to see a way to improve the
> patches. None of the suggestions so far seem to be realizable.
> 
> 

Just respin your patches then.

I suspect we'll have so few users of this API, that we can easily change
it later if really someone brings something better.

"Le mieux est l'ennemi du bien." (The perfect is the enemy of the good).


