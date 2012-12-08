Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944Ab2LHDzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 22:55:08 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:45895 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932927Ab2LHDzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 22:55:06 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+V6mBGIp6VHl5YSgQdprNqZs7Pk/1p1bDZz0QYgo
	Aj0RGdWUb5pVld
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Kent Yoder <key@linux.vnet.ibm.com>
Subject: Re: [PATCH] char/tpm: Use struct dev_pm_ops for power management
Date: Sat, 8 Dec 2012 04:55:47 +0100
User-Agent: KMail/1.13.7 (Linux/3.6.9; KDE/4.8.5; x86_64; ; )
Cc: Mathias LEBLANC <Mathias.LEBLANC@st.com>,
        "Jean-Luc BLANC" <jean-luc.blanc@st.com>,
        "Sirrix@jasper.es" <Sirrix@jasper.es>, linux-kernel@vger.kernel.org,
        Rajiv Andrade <mail@srajiv.net>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        Kent Yoder <shpedoikal@gmail.com>
References: <20121205230941.GA30394@ennui.austin.ibm.com> <1354753251-27561-1-git-send-email-peterhuewe@gmx.de> <20121206162702.GC27430@ennui.austin.ibm.com>
In-Reply-To: <20121206162702.GC27430@ennui.austin.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212080455.47586.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 6. Dezember 2012, 17:27:02 schrieb Kent Yoder:
> On Thu, Dec 06, 2012 at 01:20:51AM +0100, Peter Huewe wrote:
> > This patch converts the suspend and resume functions for
> > tpm_i2c_stm_st33 to the new dev_pm_ops.
> > 
> > Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> 
>   One minor tweak, the PM funcs need to be inside CONFIG_PM_SLEEP to
> avoid warnings when compiled without PM support.  Applied with that
> change only.
> 
> Thanks Peter!
> Kent
Great to hear!

Peter
