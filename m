Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab2LQPse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 10:48:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16141 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab2LQPsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 10:48:33 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Q2ngOrtrCvsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=op-17gKe6wkA:10 a=7d_E57ReAAAA:8 a=yPCof4ZbAAAA:8 a=132X7IMQrSRDRXADDjwA:9 a=PUjeQqilurYA:10 a=D6-X0JM3zdQA:10 a=7DSvI1NPTFQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355759311.17101.412.camel@gandalf.local.home>
Subject: Re: [PATCH 05/15] tracepoint: use new hashtable implementation
From: Steven Rostedt <rostedt@goodmis.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org
Date: Mon, 17 Dec 2012 10:48:31 -0500
In-Reply-To: <1355756497-15834-5-git-send-email-sasha.levin@oracle.com>
References: <1355756497-15834-1-git-send-email-sasha.levin@oracle.com>
	 <1355756497-15834-5-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-17 at 10:01 -0500, Sasha Levin wrote:
> Switch tracepoints to use the new hashtable implementation. This reduces the
> amount of generic unrelated code in the tracepoints.
> 
> This patch depends on d9b482c ("hashtable: introduce a small and naive
> hashtable") which was merged in v3.6.
> 
> Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


