Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab2LVDF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 22:05:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31384 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab2LVDF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 22:05:57 -0500
X-Authority-Analysis: v=2.0 cv=QPnqt33L c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=R0qdkdZMuLMA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=NBdiTfTIyVEA:10 a=20KFwNOVAAAA:8 a=MJxrH50jwXVXVaWTwd0A:9 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Date: Fri, 21 Dec 2012 22:05:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 1/3] x86,smp: move waiting on contended lock out of
 line
Message-ID: <20121222030554.GC27621@home.goodmis.org>
References: <20121221184940.103c31ad@annuminas.surriel.com>
 <20121221185038.43e8246c@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121221185038.43e8246c@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 06:50:38PM -0500, Rik van Riel wrote:
> Subject: x86,smp: move waiting on contended ticket lock out of line
> 
> Moving the wait loop for congested loops to its own function allows
> us to add things to that wait loop, without growing the size of the
> kernel text appreciably.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

