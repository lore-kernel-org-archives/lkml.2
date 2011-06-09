Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab1FIDTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 23:19:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59751 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab1FIDTJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 23:19:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JdK0hc81qr2UKeWoOUKOz0BgM1LYvSldIuO1UOfoywzOnbrhA9VWYbuvIrdhaHjqqg
         sE31DnJFk36OwtpnAG17Lbsi37u3wZ8ZHGNKOzyWDiQwpjOjvWSD/LercpLCpWjslpQV
         dNyz1hmRJ6KzyjuVfLaFyj54Coy+FItkcY8TY=
MIME-Version: 1.0
In-Reply-To: <cover.1307587586.git.panweiping3@gmail.com>
References: <cover.1307587586.git.panweiping3@gmail.com>
Date: Thu, 9 Jun 2011 11:19:09 +0800
Message-ID: <BANLkTi=xoCJUZAfHBR18bs_WmXwD7rt58g@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] bonding: delete two unused variables
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Weiping Pan <panweiping3@gmail.com>
Cc: fubar@us.ibm.com, andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 10:51 AM, Weiping Pan <panweiping3@gmail.com> wrote:
> Delete two unused variables in bonding.
>
> Weiping Pan (2):
>  bonding: delete unused ad_timer
>  bonding: delete unused arp_mon_pt
>

Both look good to me,

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.
