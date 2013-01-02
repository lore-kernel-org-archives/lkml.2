Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab3ABOFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 09:05:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab3ABOF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 09:05:29 -0500
Date: Wed, 2 Jan 2013 15:05:18 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH v4 02/18] perf/x86: improve sysfs event mapping with
 event string
Message-ID: <20130102140518.GB931@krava.brq.redhat.com>
References: <1356018108-6081-1-git-send-email-eranian@google.com>
 <1356018108-6081-3-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356018108-6081-3-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 04:41:32PM +0100, Stephane Eranian wrote:
> This patch extends Jiri's changes to make generic
> events mapping visible via sysfs. The patch extends
> the mechanism to non-generic events by allowing
> the mappings to be hardcoded in strings.
> 
> This mechanism will be used by the PEBS-LL patch
> later on.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

looks ok,

Acked-by: Jiri Olsa <jolsa@redhat.com>
