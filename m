Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab2INNy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:54:57 -0400
Received: from mout.perfora.net ([74.208.4.194]:51518 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902Ab2INNyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:54:54 -0400
Date: Fri, 14 Sep 2012 09:54:30 -0400
From: Jim Rees <rees@umich.edu>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Bernd Petrovitsch <bernd@petrovitsch.priv.at>,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] strings: helper for maximum decimal encoding of an
 unsigned integer
Message-ID: <20120914135430.GC8943@umich.edu>
References: <20120821212910.GD18637@fieldses.org>
 <alpine.LNX.2.01.1209100803060.22738@frira.zrqbmnf.qr>
 <1347614276.26071.15.camel@thorin>
 <20120914123014.GB29160@umich.edu>
 <alpine.LNX.2.01.1209141501450.18169@frira.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1209141501450.18169@frira.zrqbmnf.qr>
X-Provags-ID: V02:K0:YVlEV7+nmA/GGXhDDM4260/ZGpkbgVU85gOBGUWChqz
 Ehnu8f0B6z5UZcfEyNsK17iAKVT4P52EXUcH+8fRN3iT//9mAk
 w2sKerubI8zk6MDKpawazlm8tcwutnjyM798fN88gMo9/Er09L
 9hdujie5uEEKF8o6SwKIb+lAu1k+Z9s6a+Jmu84Fdbu05UqB+d
 8HTiy02Upwsq5JubMRKij+45e1ob6iKY8KpYoJH2opXW9hQK+5
 K6xV48Zh9uTcEasLHbxR+Nf0sZfsCIiiWrqNO9MH2tH7eP8pW0
 CUWMoOK9vcgT4kU+/EMQTM7+GhGgoulSZbVf6XXgeUKrNAyqw=
 =
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:

  Your way does not function as originally desired.
  
   * base10len(i) no longer expands to a compile-time constant
  
   * you will definitely have a variable base10len_vals in your
     objects, so you waste a read operation whenever it is used.

No, I meant my original way:
#define base10len(i) (sizeof(i) * 8 * 3 / 10 + 1)
