Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab0DGBnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 21:43:09 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38375 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932454Ab0DGBnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 21:43:05 -0400
Date: Wed, 7 Apr 2010 07:12:58 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip] kprobes: Move enable/disable_kprobe() out from
	debugfs code
Message-ID: <20100407014258.GA15311@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <4BB5FED3.4020809@redhat.com> <20100406222452.13879.48199.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100406222452.13879.48199.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 06:24:52PM -0400, Masami Hiramatsu wrote:
> Move enable/disable_kprobe() API out from debugfs related code,
> because these interfaces are not related to debugfs interface.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Reported-by: Tony Luck <tony.luck@intel.com>

Acked-by:  Ananth N Mavinakayanahalli <ananth@in.ibm.com>
