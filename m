Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab1KIOnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 09:43:06 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:56380 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab1KIOnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 09:43:04 -0500
Date: Wed, 9 Nov 2011 15:42:59 +0100
From: Borislav Petkov <bp@amd64.org>
To: Niklas =?iso-8859-1?Q?S=F6derlund?= 
	<niklas.soderlund@ericsson.com>
Cc: dougthompson@xmission.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd64_edac: fix size decoding error on K8
Message-ID: <20111109144258.GD30472@aftab>
References: <1320849178-23340-1-git-send-email-niklas.soderlund@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1320849178-23340-1-git-send-email-niklas.soderlund@ericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 03:32:58PM +0100, Niklas Söderlund wrote:
> Use a lookup table to calculate the size of a chip select. The old
> method of calculating size return erroneous values for some memory
> configurations.

Can you elaborate more on those erroneous values, please?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
