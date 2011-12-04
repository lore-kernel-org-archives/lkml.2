Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab1LDQxx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 11:53:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53152 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab1LDQxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 11:53:50 -0500
X-Authority-Analysis: v=2.0 cv=bdLpoZzB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=K6bUauivbxgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=naLLOZELvtwWruvr148A:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 04/10] KVM: Sanitize cpuid
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>, John Kacur <jkacur@redhat.com>,
        Avi Kivity <avi@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
In-Reply-To: <alpine.LFD.2.02.1112031729570.2735@ionos>
References: <20111203014641.165123482@goodmis.org>
	 <20111203014745.894197548@goodmis.org>
	 <alpine.LFD.2.02.1112031729570.2735@ionos>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 04 Dec 2011 11:53:45 -0500
Message-ID: <1323017625.19933.7.camel@pippen.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-12-03 at 17:31 +0100, Thomas Gleixner wrote:
> On Fri, 2 Dec 2011, Steven Rostedt wrote:
> 
> You forgot to pick the other fix, which makes the cpuid stuff really
> work: commit 02668b061 (KVM: fix XSAVE bit scanning (now properly))


Thanks, I'll add it for rc2.

-- Steve


