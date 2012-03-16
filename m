Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161975Ab2CPWrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 18:47:20 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51988 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab2CPWrT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 18:47:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120316175118.GI18218@redhat.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2E32064CDF@USINDEVS01.corp.hds.com>
	<20120316175118.GI18218@redhat.com>
Date: Fri, 16 Mar 2012 15:47:18 -0700
Message-ID: <CA+8MBbJEvOc0Y8nzpNjJ2tWA=Oc9XWskP_qUGMGwdBX1+9sU7Q@mail.gmail.com>
Subject: Re: [Patch]Introduce get_reason_str() to pstore
From: Tony Luck <tony.luck@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen Gong (gong.chen@linux.intel.com)" <gong.chen@linux.intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Future proofs things a little bit.  Looks good to me.
>
> Acked-by: Don Zickus <dzickus@redhat.com>

Looks good to me too. Applied.

Should show up in the next linux-next tree. Will ask Linus to pull in
next merge window.

-Tony
