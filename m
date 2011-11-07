Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab1KGNBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 08:01:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33826 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab1KGNBX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 08:01:23 -0500
Subject: Re: [PATCH] perf: do not set task_ctx pointer in cpuctx if there is
 no events in the context
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Mon, 07 Nov 2011 14:00:11 +0100
In-Reply-To: <20111103074104.GG14726@redhat.com>
References: <20111023171033.GI17571@redhat.com>
	 <20111103074104.GG14726@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320670811.18053.33.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 09:41 +0200, Gleb Natapov wrote:
> Ingo, Peter can you look into this please.

queued it and the jump_label thing.
