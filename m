Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab2C2Gdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 02:33:36 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:43007 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741Ab2C2Gd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 02:33:29 -0400
Message-ID: <4F740235.7090508@msgid.tls.msk.ru>
Date: Thu, 29 Mar 2012 10:33:25 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] kvm-amd: Auto-load on CPUs with SVM.
References: <20120321063350.GA3468@leaf> <4F72F549.6060407@redhat.com> <20120328183228.GA24889@leaf>
In-Reply-To: <20120328183228.GA24889@leaf>
X-Enigmail-Version: 1.3.4
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.03.2012 22:32, Josh Triplett wrote:
> Enable x86 feature-based autoloading for the kvm-amd module on CPUs
> with X86_FEATURE_SVM.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

It appears to work fine on my amd boxen.  The only problem
is that I've no idea when it will be possible to finally
disable the init script (shipped in Debian and other distros)
to load the module based on /proc/cpuinfo contents.  It will
do nothing on kernels with this (or kvm-intel) change applied,
but we still need to support older kernels without that feature... :)

Josh, and I'm sure you will be the first who'll file a bugreport
against qemu-kvm in Debian requesting the startup script to be
removed!.. ;))

Thanks,

/mjt
