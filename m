Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab2BLSow (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 13:44:52 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:55288 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056Ab2BLSou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 13:44:50 -0500
Date: Sun, 12 Feb 2012 19:44:45 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 01/31] events/hw_event: Create a Hardware Events
 Report Mecanism (HERM)
Message-ID: <20120212184445.GA2080@aftab>
References: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
 <1328832090-9166-2-git-send-email-mchehab@redhat.com>
 <20120210134115.GC16783@aftab>
 <4F35270F.1020402@redhat.com>
 <20120212124825.GC32467@aftab>
 <4F37F526.8090907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F37F526.8090907@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 12, 2012 at 03:21:42PM -0200, Mauro Carvalho Chehab wrote:
> As I said before, there's just one trace call for memory error events 
> (hw_event:mc_error) on my second RFC.

Are you kidding me:

$ grep -EriIno "trace_.*\W" patch01.txt

...

TRACE_EVENT(mc_corrected_error,
TRACE_EVENT(mc_uncorrected_error,
TRACE_EVENT(mc_corrected_error_fbd,
TRACE_EVENT(mc_uncorrected_error_fbd,
TRACE_EVENT(mc_out_of_range,
TRACE_EVENT(mc_corrected_error_no_info,
TRACE_EVENT(mc_uncorrected_error_no_info,

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
