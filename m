Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab2CDAVP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 19:21:15 -0500
Received: from solo.fdn.fr ([80.67.169.19]:38076 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797Ab2CDAVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 19:21:14 -0500
Date: Sun, 4 Mar 2012 01:21:11 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: "John G. Heim" <jheim@math.wisc.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: speakup bug
Message-ID: <20120304002111.GP4180@type.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	"John G. Heim" <jheim@math.wisc.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <BFFDBC9B6BA14BE1AC8E266A3A456A63@hinkle>
 <20120303173916.7eca9391@pyramind.ukuu.org.uk>
 <FD8CB954D8084F998E24C4558E41C627@hinkle>
 <20120304001806.GO4180@type.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120304001806.GO4180@type.famille.thibault.fr>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Thibault, le Sun 04 Mar 2012 01:18:06 +0100, a écrit :
> Just for the record: what we need is being able to open a serial port
> and read/write from inside the kernel. Using a daemon that does the open
> and setting up speakup as a line discipline would be possible, but it
> then depends on / working, and that's not something e.g. administrators
> can really afford depending on.

BTW: yes, that does not mean that speakup couldn't use a line discipline
already. Sure, still on the TODO list for years too.

Samuel
