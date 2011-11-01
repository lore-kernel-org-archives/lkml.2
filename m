Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab1KATPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 15:15:31 -0400
Received: from nm14-vm3.bullet.mail.ne1.yahoo.com ([98.138.91.144]:21299 "HELO
	nm14-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754142Ab1KATPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 15:15:30 -0400
X-Yahoo-Newman-Id: 483195.75088.bm@smtp111.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: T0CZLAUVM1kfhaPVMmqMBOF_HVVJ.l4AxY2RQp0RxK0vPwH
 xe0Cs1R8Rfr1FzHTkAqIHDqfAL1kvLsONtnhcQIce1AKZqxXYL74LcAvuLDi
 1Mr1jztJrpzetcsA5l4uFLpqiOIl7LNDBmsW3dEJm0bLBUHD98BLgIzCaM9c
 Uic_XRhCUNz32Hp1MZjSZHJuCYStlcln8mQ7hSA19.k3dUSZ0XoBV8G86Wro
 FJ8p5kyLOfbpdM976ywyE920IdSBs7jI2twyGDntZOHRS8MCzPJuusLwIvoy
 _s4toLsdkGCs23UQcTiUrZCdy2Gopxmrz.iFVuZYtj_MHGCiDkGW9A1DPjSx
 ArvnP5zxbQUvG0pW6.TEu6B1gFhFE6Ydce00jh5ihGveFBn3Q
X-Yahoo-SMTP: gvIQca6swBCF5pMq54eC.XuJ8SoqXA5fBgqzSmaH
Date: Tue, 1 Nov 2011 14:15:16 -0500
From: Andrew Watts <akwatts@ymail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        dmitry.torokhov@gmail.com
Subject: Re: [REGRESSION]: hibernate/sleep regression w/ bisection
Message-ID: <20111101191459.GA2748@zeus>
References: <20111101124759.GA1326@zeus>
 <20111101164235.GS18855@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111101164235.GS18855@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 09:42:35AM -0700, Tejun Heo wrote:
> 
> Does the following patch fix the problem?
> 
> Thanks.

Unfortunately, it does not fix the problem.

~ Andy
