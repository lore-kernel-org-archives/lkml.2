Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab0KKOKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 09:10:44 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57541 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab0KKOKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 09:10:43 -0500
Date: Thu, 11 Nov 2010 15:09:32 +0100
From: Borislav Petkov <bp@amd64.org>
To: Tracey Dent <tdent48227@gmail.com>
Cc: "mchehab@redhat.com" <mchehab@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Drivers: edac: Makfile: Cleaned up Makefile
Message-ID: <20101111140932.GB21803@aftab>
References: <1289141013-1399-1-git-send-email-tdent48227@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289141013-1399-1-git-send-email-tdent48227@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 09:43:33AM -0500, Tracey Dent wrote:
> Changed Makefile to use <modules>-y instead of <modules>-objs because -objs is
> deprecated and should now be switched. According to (documentation/kbuild/makefiles.txt).
> 
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>

Applied, thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
