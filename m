Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab2HMNQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 09:16:45 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:37036 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751507Ab2HMNQo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 09:16:44 -0400
Message-ID: <1344863784.17900.440.camel@thor.local>
Subject: Re: [PATCH V2] drm/radeon: Include swiotlb.h if SWIOTLB configured.
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Huacai Chen <chenhc@lemote.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Alex Deucher <alexdeucher@gmail.com>, Hongliang Tao <taohl@lemote.com>,
        Hua Yan <yanh@lemote.com>
Date: Mon, 13 Aug 2012 15:16:24 +0200
In-Reply-To: <1344861653-27261-1-git-send-email-chenhc@lemote.com>
References: <1344861653-27261-1-git-send-email-chenhc@lemote.com>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAADBQTFRFDg4OHh4eLCwsOzs7S0tLWlpaa2treXl5hISEjY2NmJiYqKiotLS0xsbG1dXV/Pz81CO0SQAAArtJREFUOMtd1M9P01AcAHCI/4AtGq/QDfDHRfraEX8eaNeJFw1rO/DCYet7mxc1ZG0x3sStHQkmZpqtHDwAi+tMiFEzbZdwNWEJR48cjPG4g5HhELUbrHvjpYe2n7zvt++977cD/7rjsCry8uNG93Gge9OKUyAAgLB1AlpTZICmAzR15QTEiQAPAKADYLMPfhNnEJR4HvD0tT5YI2KGUcyqihQN7mDwZ3hMN4q2N4ol+gEGTSLWhorrjYXrGPwc0jTDOoKP4xi8G0W6adl2Gz6zGDwag5p5PMON7vZgJuSB976+3U6y2QdeKNet1+uum9/qwVQHvEjtKesY0EIb7CNYe+7DIRXCID/vQ4tksVAY7JFBD7yvqrWTL93xoUmOQsPIddbnuk8v+bBPsigB2KRlFxS4nL/owwEpKBSg2MU3UcDf+nATyyHEQwrHzJZFNpXeuOHDC0qW4sMhEHESFGOUrvgQpWUYFVNQdjQxca8abnSB55CmehdcLSxa1ifoQ4JBpmGYWbhsly3X0fxQ7xmkW3Y5CztLcXI+fAu2oWho3nbV6s5rH35xSC/aBR2tOpVa/Utv25tcTDPL6aT21kG17WrvaFtMBJmFhJCsVF4uu9VG76DWBaRnEiNs7pU659pYlfwtQSRy9GCYlwR7C6/dPQgBw3MsTPNWA4d9SeMDDC9JYdnqq/amdF+diGnVhXFztQ/2lJSWjulOxjRX+uC7EkOqhLRk2ejrqHVBEqCqJLO5cmEXgx8TrBiWVQh1u2DhzQlPsyIveU2YLGorGBxODoR5notlpcUieoLB1/NEmGc4AalGJpLe8WF/8txMWASAkVVViQjzP
 jycPrvgA
	R1goSzOnkp14YCYHsp7QJHAS5QcXDqG1jBxdSITVgBNkBTFloj88Q/gMkFcuItYiQPUCBGc2xh5drsD/wGZrgsgDOE4ZAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1.0 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-13 at 20:40 +0800, Huacai Chen wrote: 
> When SWIOTLB is configured, if without this patch kernel compilation
> fails with such error messages:
> 
> drivers/gpu/drm/radeon/radeon_ttm.c: In function 'radeon_ttm_tt_populate':
> drivers/gpu/drm/radeon/radeon_ttm.c:606:2: error: implicit declaration of function 'swiotlb_nr_tbl'
> drivers/gpu/drm/radeon/radeon_ttm.c:607:3: warning: passing argument 2 of 'ttm_dma_populate' from incompatible pointer type
> include/drm/ttm/ttm_page_alloc.h:81:12: note: expected 'struct device *' but argument is of type 'struct device *'
> drivers/gpu/drm/radeon/radeon_ttm.c: In function 'radeon_ttm_tt_unpopulate':
> drivers/gpu/drm/radeon/radeon_ttm.c:653:3: warning: passing argument 2 of 'ttm_dma_unpopulate' from incompatible pointer type
> include/drm/ttm/ttm_page_alloc.h:82:13: note: expected 'struct device *' but argument is of type 'struct device *'
> 
> V2:
> 1, Add compilation error messages;
> 2, Make the From: address the same as Signed-off-by address.
> 
> Signed-off-by: Huacai Chen <chenhc@lemote.com>

Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>


-- 
Earthling Michel Dänzer           |                   http://www.amd.com
Libre software enthusiast         |          Debian, X and DRI developer
