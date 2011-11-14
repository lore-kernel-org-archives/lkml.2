Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab1KNUzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 15:55:22 -0500
Received: from nm2-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.248]:48985 "HELO
	nm2-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752421Ab1KNUzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 15:55:20 -0500
X-Yahoo-Newman-Id: 707718.49224.bm@smtp225.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: HQHt0s8VM1ksBZQGyWH0TIY_j0nZ9YV7KzXEXqDfiDOs0ck
 gnnx1nmwdPWzKLVySDeKajhvtAEuVi.xE3HycCJXKfpP7MCxsodOrmAIXrFy
 4NUJEIv1YuriJthM2cR23_KSy5WCKc_wkH9mgS8hcI3_FvSXD3kg8npW5VF3
 Owwf3utP7I8gpwUYMc0rKM.3ETbyUN9UCmiexIe9jpsfIGa4DPh6H20ieYQs
 qw3oHBWf6c7wAjMTGqWkYN0C7bu.TLTPrvz7YCdfIU_inGJCBTkGd_nB_LGi
 QBehCA20pL0I8MWYrjJRDzVqJ_nGahk8NNNtG7Sa6YMWqAU8_qml.0PVj3PP
 74d6lUv3uEWugTn7wJ5Go4lFrD1DJ6cfgZwXhSzWujYAdqufM
X-Yahoo-SMTP: gvIQca6swBCF5pMq54eC.XuJ8SoqXA5fBgqzSmaH
Date: Mon, 14 Nov 2011 15:53:24 -0500
From: Andrew Watts <akwatts@ymail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [OOPS]: Kernel 3.1 (ext3?)
Message-ID: <20111114205304.GA5542@zeus>
References: <20111110132929.GA11417@zeus>
 <20111114195352.GB17328@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111114195352.GB17328@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 08:53:52PM +0100, Jan Kara wrote:
>   Hmm, the report is missing a line (top one) saying why the kernel
> actually crashed. Can you add that?
> 
>   Also it seems you are using SLUB allocator, right? This seems like a
> problem there so adding some CCs.

Hi Jan.

Unfortunately, the oops trace is a transcription of all that was left on
my screen. I hope that can provide enough clues into what is going on.

Yes, I use the SLUB allocator.

Thank you for your reply and for adding revelant cc's.

~ Andy

