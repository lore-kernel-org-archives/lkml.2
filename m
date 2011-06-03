Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab1FCTEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 15:04:22 -0400
Received: from lo.gmane.org ([80.91.229.12]:55710 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755659Ab1FCTEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 15:04:20 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: [PATCH] perf: make annotate more readable
Date: Fri, 03 Jun 2011 20:04:07 +0100
Message-ID: <yw1xzkly3ffc.fsf@unicorn.mansr.com>
References: <20110517153207.GA9834@quad>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: unicorn.mansr.com
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
Cancel-Lock: sha1:oxu3zV7uC3sQdEOlIALoloKaErE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian <eranian@google.com> writes:

> This patch adds two new options to perf annotate:
> 	- -R, --no-asm-raw : do not display raw instruction encodings
> 	- -S, --no-source  : do not interleave source code with assembly code
>
> We believe those options make the output of annotate more readable.
> Systematically displaying source can make it hard to follow code and
> especially optimized code.
>
> Raw encodings are not useful in most cases.

Would it be possible to have it display only the source like opannotate
can do?

-- 
Måns Rullgård
mans@mansr.com

