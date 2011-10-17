Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab1JQIzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 04:55:05 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33776 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab1JQIzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 04:55:02 -0400
Date: Mon, 17 Oct 2011 10:55:46 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: Problems with videos and i915 driver
Message-ID: <20111017085546.GB2971@phenom.ffwll.local>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org
References: <1318788068.12224.125.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318788068.12224.125.camel@gandalf.stny.rr.com>
X-Operating-System: Linux phenom 3.0.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 16, 2011 at 02:01:08PM -0400, Steven Rostedt wrote:
> [  102.695526] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
> [  102.695538] [drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
> [  102.699680] [drm:i915_wait_request] *ERROR* i915_wait_request returns -11 (awaiting 1 at 0, next 2)

Can you please attach i915_error_state? It contains the gpu crashdump we
need to diagnose gpu hangs.

Thanks, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
