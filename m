Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab1G2RHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 13:07:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51739 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab1G2RHn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 13:07:43 -0400
Subject: Re: [PATCH 0/7] perf, x86: Implement AMD IBS
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 29 Jul 2011 19:07:16 +0200
Message-ID: <1311959236.5890.420.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-28 at 15:46 +0200, Robert Richter wrote:
> This patch set adds support for AMD IBS to perf. 

> The approach is still to collect raw sample data which should be the
> most important use case for application developers. The data format is
> the same as described in the IBS register specification.

That makes it hardware dependent right? I take it new hardware with IBS
extensions adds output MSRs.

Anyway, I'll try and go over it again next week after reading the IBS
hardware spec (again.. that stuff just won't stick to memory).

I've got the BKDG for Fam10, is there anything more I should read?
