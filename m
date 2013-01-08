Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab3AHViq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:38:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5111 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab3AHVin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:38:43 -0500
X-Authority-Analysis: v=2.0 cv=T70Ovo2Q c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=O_67QizI8w0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=fLyonxBqlDMA:10 a=SbwudO-BzbdwtYbHyIMA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357681121.5190.42.camel@gandalf.local.home>
Subject: [add to stable] ftrace: Do not function trace inlined functions
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 08 Jan 2013 16:38:41 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg and Ben,

Can you add commit 45959ee7aa645815a5ce303a0ea1e48a21e67c6a to the
stable trees.

Thanks,

-- Steve


