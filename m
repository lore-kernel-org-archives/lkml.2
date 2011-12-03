Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab1LCQbc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 11:31:32 -0500
Received: from www.linutronix.de ([62.245.132.108]:50925 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab1LCQbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 11:31:31 -0500
Date: Sat, 3 Dec 2011 17:31:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>, John Kacur <jkacur@redhat.com>,
        Avi Kivity <avi@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 04/10] KVM: Sanitize cpuid
In-Reply-To: <20111203014745.894197548@goodmis.org>
Message-ID: <alpine.LFD.2.02.1112031729570.2735@ionos>
References: <20111203014641.165123482@goodmis.org> <20111203014745.894197548@goodmis.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Dec 2011, Steven Rostedt wrote:

You forgot to pick the other fix, which makes the cpuid stuff really
work: commit 02668b061 (KVM: fix XSAVE bit scanning (now properly))

Thanks,

	tglx

