Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215Ab2EKQtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 12:49:17 -0400
Received: from mail.telros.ru ([83.136.244.21]:63389 "EHLO mail.telros.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992Ab2EKQtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 12:49:15 -0400
Date: Fri, 11 May 2012 20:49:07 +0400
From: volokh@telros.ru
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: volokh84@gmail.com, mchehab@infradead.org, gregkh@linuxfoundation.org,
        dhowells@redhat.com, rdunlap@xenotime.net, pete@sensoray.com,
        pradheep.sh@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Volokh Konstantin <my84@bk.ru>
Subject: Re: [PATCH] staging: media: go7007: Adlink MPG24 board issues
Message-ID: <20120511164907.GA16306@VPir.telros.lan>
References: <1336714980-13460-1-git-send-email-volokh84@gmail.com>
 <4FAD1FAD.4020508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAD1FAD.4020508@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>some simple stuff I found along the way..

On 05/10/2012 10:43 PM, volokh84@gmail.com wrote:
> From: Volokh Konstantin<my84@bk.ru>                                                                          
>                                                                                                              
> This issuses applyed only for Adlink MPG24 board with go7007                                                 

>>this issue applies only for...

>   &  wis2804, all whese changes was tested for continuos                                                     
>   load&restart mode                                                                                          
>                                                                                                              

>>these changes were tested for continuous

> This is minimal changes needed for start up go7007&wis2804 to work correctly                                 
>    in 3.4 branch                                                                                             
>                                                                                                              
> Changes:                                                                                                     
>    - When go7007 reset device, i2c was not worked (need rewrite GPIO5)                                       

>>working

>    - As wis2804 has i2c_addr=0x00/*really*/, so Need set I2C_CLIENT_TEN flag for validity                    
>    - some main nonzero initialization, rewrites with kzalloc instead kmalloc                                 
>    - STATUS_SHUTDOWN was pl


Thanks for english language notation.
I`ve never used it in real word.
