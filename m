Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab2DEGGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 02:06:33 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:40608 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab2DEGGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 02:06:31 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q3566EIG008294, This message is released by code: ctlocs8528
From: hayeswang <hayeswang@realtek.com>
To: "'Francois Romieu'" <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1333089184-1773-5-git-send-email-hayeswang@realtek.com> <1333090086-1815-1-git-send-email-hayeswang@realtek.com> <20120330072521.GA11548@electric-eye.fr.zoreil.com>
Subject: RE: [PATCH net-next v3 5/5] r8169: support RTL8411
Date: Thu, 5 Apr 2012 14:06:14 +0800
Message-ID: <52E71C7B42A44FB1A8556BB6B75CD9A0@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac0ORqwvFC6oGnrgQRmX3vc6XKGH7QEqjRGg
In-Reply-To: <20120330072521.GA11548@electric-eye.fr.zoreil.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu [mailto:romieu@fr.zoreil.com] 
> Sent: Friday, March 30, 2012 3:25 PM
> To: Hayeswang
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next v3 5/5] r8169: support RTL8411
> 
> Hayes Wang <hayeswang@realtek.com> :
> > Support the new chip RTL8411.
> > 
> > Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> 
> I do not see any change related to rtl_init_jumbo_ops. If 
> NULL is ok for
> jumbo_{enable / disable}, it deserves to be outlined in the commit
> message.
> 
> No reviewer can figure what's going on otherwise.
> 

There is nothing to do for rtl_init_jumbo_ops. It is all right for keeping NULL.
Do I need to resend this patch?
 
Best Regards,
Hayes

