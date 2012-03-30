Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760853Ab2C3NKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 09:10:50 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:43579 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760839Ab2C3NKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 09:10:44 -0400
Date: Fri, 30 Mar 2012 15:10:37 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/13] edac: move dimm properties to struct memset_info
Message-ID: <20120330131037.GB30876@aftab>
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com>
 <1333039546-5590-3-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333039546-5590-3-git-send-email-mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please don't call it 'memset_info' - this is misleading beyond belief.

Hmm, what struct memset_info - where the hell is this? It is nowhere to
be seen in the patches following that one too, WTF?

On Thu, Mar 29, 2012 at 01:45:35PM -0300, Mauro Carvalho Chehab wrote:
> On systems based on chip select rows, all channels need to use memories
> with the same properties, otherwise the memories on channels A and B
> won't be recognized.
> 
> However, such assumption is not true for all types of memory
> controllers.
> 
> Controllers for FB-DIMM's don't have such requirements.
> 
> Also, modern Intel controllers seem to be capable of handling such
> differences.
> 
> So, we need to get rid of storing the DIMM information into a per-csrow
> data, storing it, instead at the right place.
> 
> The first step is to move grain, mtype, dtype and edac_mode to the
> per-dimm struct.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
