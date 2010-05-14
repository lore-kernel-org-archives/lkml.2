Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759717Ab0ENUqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 16:46:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753446Ab0ENUqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 16:46:47 -0400
Date: Fri, 14 May 2010 13:46:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, gregkh@suse.de,
       alan@lxorguk.ukuu.org.uk, tytso@mit.edu, iws@ovro.caltech.edu
Subject: Re: [PATCH 4/4] add example files to the kernel sample directory
Message-Id: <20100514134609.54e05968.akpm@linux-foundation.org>
In-Reply-To: <1273654167-31067-5-git-send-email-stefani@seibold.net>
References: <1273654167-31067-1-git-send-email-stefani@seibold.net>
	<1273654167-31067-5-git-send-email-stefani@seibold.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 10:49:27 +0200
stefani@seibold.net wrote:

> This patch add four examples to the kernel sample directory.

x86_64 allmodconfig:

samples/kfifo/dma-example.c: In function 'example_init':
samples/kfifo/dma-example.c:27: error: array type has incomplete element type
samples/kfifo/dma-example.c:41: error: implicit declaration of function 'kfifo_put'
samples/kfifo/dma-example.c:44: error: implicit declaration of function 'kfifo_get'
samples/kfifo/dma-example.c:48: error: implicit declaration of function 'kfifo_dma_in_prepare'
samples/kfifo/dma-example.c:48: warning: type defaults to 'int' in declaration of 'type name'
samples/kfifo/dma-example.c:48: warning: type defaults to 'int' in declaration of 'type name'
samples/kfifo/dma-example.c:48: error: negative width in bit-field '<anonymous>'
samples/kfifo/dma-example.c:54: warning: type defaults to 'int' in declaration of 'type name'
samples/kfifo/dma-example.c:54: warning: type defaults to 'int' in declaration of 'type name'
samples/kfifo/dma-example.c:54: error: negative width in bit-field '<anonymous>'
samples/kfifo/dma-example.c:60: error: implicit declaration of function 'sg_is_last'
samples/kfifo/dma-example.c:71: error: implicit declaration of function 'kfifo_dma_in_finish'
samples/kfifo/dma-example.c:74: error: implicit declaration of function 'kfifo_dma_out_prepare'
samples/kfifo/dma-example.c:74: warning: type defaults to 'int' in declaration of 'type name'
samples/kfifo/dma-example.c:74: warning: type defaults to 'int' in declaration of 'type name'
samples/kfifo/dma-example.c:74: error: negative width in bit-field '<anonymous>'
samples/kfifo/dma-example.c:80: warning: type defaults to 'int' in declaration of 'type name'
samples/kfifo/dma-example.c:80: warning: type defaults to 'int' in declaration of 'type name'
samples/kfifo/dma-example.c:80: error: negative width in bit-field '<anonymous>'
samples/kfifo/dma-example.c:97: error: implicit declaration of function 'kfifo_dma_out_finish'
samples/kfifo/dma-example.c:27: warning: unused variable 'sg'
make[2]: *** [samples/kfifo/dma-example.o] Error 1
make[2]: *** Waiting for unfinished jobs....
samples/kfifo/bytestream-example.c:44:52: error: macro "DECLARE_KFIFO" passed 3 arguments, but takes just 2
samples/kfifo/bytestream-example.c:44: warning: type defaults to 'int' in declaration of 'DECLARE_KFIFO'
samples/kfifo/bytestream-example.c: In function 'testfunc':
samples/kfifo/bytestream-example.c:56: error: 'test' undeclared (first use in this function)
samples/kfifo/bytestream-example.c:56: error: (Each undeclared identifier is reported only once
samples/kfifo/bytestream-example.c:56: error: for each function it appears in.)
samples/kfifo/bytestream-example.c:60: error: implicit declaration of function 'kfifo_put'
samples/kfifo/bytestream-example.c:83: error: implicit declaration of function 'kfifo_get'
samples/kfifo/bytestream-example.c: In function 'fifo_write':
samples/kfifo/bytestream-example.c:99: error: 'test' undeclared (first use in this function)
samples/kfifo/bytestream-example.c: In function 'fifo_read':
samples/kfifo/bytestream-example.c:115: error: 'test' undeclared (first use in this function)
samples/kfifo/bytestream-example.c: In function 'example_init':
samples/kfifo/bytestream-example.c:139: error: 'test' undeclared (first use in this function)
samples/kfifo/bytestream-example.c:139: error: 'testkfifo_buffer' undeclared (first use in this function)
make[2]: *** [samples/kfifo/bytestream-example.o] Error 1
samples/kfifo/record-example.c:53: error: syntax error before numeric constant
samples/kfifo/record-example.c:53: warning: type defaults to 'int' in declaration of 'mytest'
samples/kfifo/record-example.c:53: warning: data definition has no type or storage class
samples/kfifo/record-example.c:55: error: syntax error before 'test'
samples/kfifo/record-example.c:55: warning: type defaults to 'int' in declaration of 'test'
samples/kfifo/record-example.c:55: warning: data definition has no type or storage class
samples/kfifo/record-example.c: In function 'testfunc':
samples/kfifo/record-example.c:67: warning: passing argument 1 of 'kfifo_in' from incompatible pointer type
samples/kfifo/record-example.c:70: error: implicit declaration of function 'kfifo_peek_len'
samples/kfifo/record-example.c:75: warning: passing argument 1 of 'kfifo_in' from incompatible pointer type
samples/kfifo/record-example.c:78: warning: passing argument 1 of 'kfifo_len' from incompatible pointer type
samples/kfifo/record-example.c:81: warning: passing argument 1 of 'kfifo_out_peek' from incompatible pointer type
samples/kfifo/record-example.c:81: error: too few arguments to function 'kfifo_out_peek'
samples/kfifo/record-example.c:86: warning: passing argument 1 of 'kfifo_is_empty' from incompatible pointer type
samples/kfifo/record-example.c:87: warning: passing argument 1 of 'kfifo_out' from incompatible pointer type
samples/kfifo/record-example.c: In function 'fifo_write':
samples/kfifo/record-example.c:103: warning: passing argument 1 of 'kfifo_from_user' from incompatible pointer type
samples/kfifo/record-example.c: In function 'fifo_read':
samples/kfifo/record-example.c:119: warning: passing argument 1 of 'kfifo_to_user' from incompatible pointer type
samples/kfifo/record-example.c: In function 'example_init':
samples/kfifo/record-example.c:143: error: 'testkfifo_buffer' undeclared (first use in this function)
samples/kfifo/record-example.c:143: error: (Each undeclared identifier is reported only once
samples/kfifo/record-example.c:143: error: for each function it appears in.)
samples/kfifo/record-example.c:143: error: incompatible types in assignment
make[2]: *** [samples/kfifo/record-example.o] Error 1
samples/kfifo/inttype-example.c:44:41: error: macro "DEFINE_KFIFO" passed 3 arguments, but takes just 2
samples/kfifo/inttype-example.c:44: warning: type defaults to 'int' in declaration of 'DEFINE_KFIFO'
samples/kfifo/inttype-example.c: In function 'testfunc':
samples/kfifo/inttype-example.c:57: error: implicit declaration of function 'kfifo_put'
samples/kfifo/inttype-example.c:57: error: 'test' undeclared (first use in this function)
samples/kfifo/inttype-example.c:57: error: (Each undeclared identifier is reported only once
samples/kfifo/inttype-example.c:57: error: for each function it appears in.)
samples/kfifo/inttype-example.c:75: error: implicit declaration of function 'kfifo_peek'
samples/kfifo/inttype-example.c:79: error: implicit declaration of function 'kfifo_get'
samples/kfifo/inttype-example.c: In function 'fifo_write':
samples/kfifo/inttype-example.c:95: error: 'test' undeclared (first use in this function)
samples/kfifo/inttype-example.c: In function 'fifo_read':
samples/kfifo/inttype-example.c:111: error: 'test' undeclared (first use in this function)

