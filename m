Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab0KXIcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:32:06 -0500
Received: from canuck.infradead.org ([134.117.69.58]:53291 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab0KXIcF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:32:05 -0500
Subject: Re: [rfc 3/3] perf, x86: P4 PMU -- export ABI part of event config
 to userspace
From: Peter Zijlstra <peterz@infradead.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        ming.m.lin@intel.com, eranian@google.com
In-Reply-To: <20101123224800.658686382@openvz.org>
References: <20101123224601.766827604@openvz.org>
	 <20101123224800.658686382@openvz.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 24 Nov 2010 09:32:17 +0100
Message-ID: <1290587537.2072.430.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 01:46 +0300, Cyrill Gorcunov wrote:
> plain text document attachment (x86-perf-export-abi)
> Due to tight 64 bit size of event config field (where we have to track
> pretty lot of info during event lifetime) some bits are to be exported
> via header into userspace.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Lin Ming <ming.m.lin@intel.com>
> CC: Stephane Eranian <eranian@google.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> ---
> 
> Note that I don't like much the idea to export anything into userspace
> but it seems there is no other choise. So there is a minimum which should
> be exported.


Could you say what exactly is exposed to userspace and why?
