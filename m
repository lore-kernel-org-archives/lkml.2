Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab0KHRHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 12:07:44 -0500
Received: from smtp-out-096.synserver.de ([212.40.180.96]:1119 "HELO
	smtp-out-091.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1753869Ab0KHRHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 12:07:44 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 26651
Date: Mon, 8 Nov 2010 18:07:37 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, airlied@linux.ie
Subject: Re: Radeon RS780 - BUG: unable to handle kernel NULL pointer
 dereference
Message-ID: <20101108170737.GA1617@arch.trippelsdorf.de>
References: <20101108170221.GA1602@arch.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101108170221.GA1602@arch.trippelsdorf.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 06:02:21PM +0100, Markus Trippelsdorf wrote:
> I can trigger a kernel crash on my system by simply loading this png
> image with firefox:
> http://mediaarchive.cern.ch/MediaArchive/Photo/Public/2010/1011251/1011251_01/1011251_01-A4-at-144-dpi.jpg

Sorry the above link is wrong, this is the right one (that triggers the
crash):
http://cdsweb.cern.ch/record/1305179/files/HI-150431-630470-huge.png
-- 
Markus
