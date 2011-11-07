Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab1KGM5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:57:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33719 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab1KGM5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:57:50 -0500
Subject: Re: [RFC PATCH v2] Tracepoint: add exec tracepoint
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Smith <dsmith@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Date: Mon, 07 Nov 2011 13:56:49 +0100
In-Reply-To: <4EB2BA74.5070207@redhat.com>
References: <4EB2BA74.5070207@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320670609.18053.32.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 10:59 -0500, David Smith wrote:
> Added general purpose exec tracepoint.  The 'bprm' argument gives
> details of the exec.
> 
> 
This 'changelog' if one can call it that, is completely devoid of
rationale, why should we care and why should we merge.
