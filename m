Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751060Ab0KSFJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 00:09:43 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:48640 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab0KSFJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 00:09:42 -0500
Date: Fri, 19 Nov 2010 06:09:30 +0100
From: Borislav Petkov <bp@amd64.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: "Petkov, Borislav" <Borislav.Petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] EDAC, MCE: Fix edac_init_mce_inject error handling
Message-ID: <20101119050930.GB16472@aftab>
References: <1290135943.23599.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290135943.23599.1.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 10:05:43PM -0500, Axel Lin wrote:
> Otherwise, variable i will be -1 inside the latest iteration of the while loop.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Good catch.

Applied,
thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
