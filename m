Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab0K2Kip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 05:38:45 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62873 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab0K2Kin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 05:38:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=IZrSD6NkUJwdoAG6z6Y7O3Te67YwVSoDV4e4ZoM+GyuF/d1m1aLD4SsWmPS6+XY6jo
         Kjmt/C4zLhMJwi0iQECud0BtZejmhks/9BQBn88Ti4EXVGjdHBIP8uPNJRqbEdDvMJF6
         Y9h5Su9+lMoaVf9AqnSVxpgo2yy2xurUXFxRc=
Subject: Re: VT console need rewrite
From: Microcai <microcai@fedoraproject.org>
Reply-To: microcai@fedoraproject.org
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        Lisa Milne <lisa@ltmnet.com>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
In-Reply-To: <20101129101702.GS5142@const.bordeaux.inria.fr>
References: <1290951770.13526.18.camel@cai.gentoo>
	 <AANLkTimQDWHo4-8-H+5bB_uzrgzU=gqbDBuerq983moR@mail.gmail.com>
	 <20101129020610.7ea7c79e.lisa@ltmnet.com>
	 <1290961207.13526.31.camel@cai.gentoo> <20101128194624.GP2767@thunk.org>
	 <1290993244.877.3.camel@cai.gentoo>
	 <20101129085829.GM5142@const.bordeaux.inria.fr>
	 <1291023157.9785.2.camel@cai.gentoo>
	 <20101129095823.GQ5142@const.bordeaux.inria.fr>
	 <1291025476.9785.5.camel@cai.gentoo>
	 <20101129101702.GS5142@const.bordeaux.inria.fr>
Content-Type: text/plain; charset="UTF-8"
Organization: fedoraproject.org
Date: Mon, 29 Nov 2010 18:40:00 +0800
Message-ID: <1291027200.9785.9.camel@cai.gentoo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2010-11-29一的 11:17 +0100，Samuel Thibault写道：
> It seems you didn't get my point: what is the use of including CJK
> into
> kernel when that won't solve the issue for e.g. arabic, while fixing
> fbterm will solve the issue for both arabic and CJK?
> 

You don't get my point.  fbterm of zhcon won't fit every thing.


