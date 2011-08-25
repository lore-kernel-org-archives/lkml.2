Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab1HYOXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 10:23:55 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:28384 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750917Ab1HYOXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 10:23:53 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 2oE.3qQVM1njdix9g9O_u97yl70ARakiMnAzOQWz5J.S_bG
 aN18GqOGdO1kLj6TFugWSAKM64maAE0iXzMADdpoQsikyVQxtC2HfEFzG3rx
 iUPS9RCczBj.6RXIFEoM8vzMehyNJb5KegAmzv.eFb45Wlzfq21642BGYLWX
 g_dGkFGY..ChTtqH0TgBha7qAJFjN1TSm7YvPoHcxBg_bacJBWkqVJPTAHrZ
 wJiSVl2YYNhADHlnJL5fYwm..rKLAvsSp5SNSd2Ce8ykkMaT2IuZSizqD.ek
 N.0NCYLzqS3eEITKa7LlrBOeGEvl_Ki59Ly1s_OjgUZfbhLjxPaCYeGSuxNE
 Q.X6kmnxC0wEdShKOOWpQAvzEGYQmh1KxlQeH1CXS24NSSln05P15b6uPLpX
 v.ptzQHW66pHua7U_ybLJ
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 25 Aug 2011 09:23:50 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Akinobu Mita <akinobu.mita@gmail.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-mm@kvack.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH -mmotm] lib/string.c: fix kernel-doc for memchr_inv
In-Reply-To: <1314281680-21553-1-git-send-email-akinobu.mita@gmail.com>
Message-ID: <alpine.DEB.2.00.1108250923350.27407@router.home>
References: <1314281680-21553-1-git-send-email-akinobu.mita@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011, Akinobu Mita wrote:

> This fixes kernel-doc for memchr_inv() which is introduced by
> lib-stringc-introduce-memchr_inv.patch in mmotm 2011-08-24-14-08

Reviewed-by: Christoph Lameter <cl@linux.com>
