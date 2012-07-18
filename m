Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab2GRW6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 18:58:21 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:54517 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab2GRW5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 18:57:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Strake <strake888@gmail.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fbdev: Add ioctls FBIO_COPYRECT, FBIO_FILLRECT, lest these operations be done in software.
Date: Thu, 19 Jul 2012 00:57:47 +0200
Message-ID: <2444839.KFfsli056l@avalon>
User-Agent: KMail/4.8.3 (Linux/3.3.8-gentoo; KDE/4.8.3; x86_64; ; )
In-Reply-To: <CAL3m8eA=46wdwVosiE54eNx3FOuLyxfE5axKs_HjyMTGxDHRDw@mail.gmail.com>
References: <CAL3m8eA=46wdwVosiE54eNx3FOuLyxfE5axKs_HjyMTGxDHRDw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 June 2012 07:22:50 Strake wrote:
> From: Matthew Farkas-Dyck <strake888@gmail.com>
> 
> Add ioctls FBIO_COPYRECT, FBIO_FILLRECT, lest these operations be done
> in software.
> 
> Signed-off-by: Matthew Farkas-Dyck <strake888@gmail.com>
> ---
> 
> Reason: If it can be done in hardware, it ought to be. This will
> enable user-mode software to do so.

If we really want to go this way, I think we should develop a proper 2D 
acceleration API. I'm not sure whether it's worth the effort though.

-- 
Regards,

Laurent Pinchart

