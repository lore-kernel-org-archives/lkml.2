Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab2BEVEn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 16:04:43 -0500
Received: from isilmar-3.linta.de ([188.40.101.200]:37568 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751654Ab2BEVEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 16:04:42 -0500
Date: Sun, 5 Feb 2012 21:31:33 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpupower: Fix linking with --as-needed
Message-ID: <20120205203133.GA11621@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>,
	linux-kernel@vger.kernel.org
References: <1326981996-17842-1-git-send-email-ozan@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1326981996-17842-1-git-send-email-ozan@pardus.org.tr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 04:06:36PM +0200, Ozan Çağlayan wrote:
> Fix linking order to avoid undefined reference errors when
> using --as-needed linker flag.

Applied, thanks.

Best,
	Dominik
