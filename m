Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab0G1S3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 14:29:23 -0400
Received: from ppsw-30.csi.cam.ac.uk ([131.111.8.130]:38389 "EHLO
	ppsw-30.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab0G1S3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 14:29:22 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C5077A0.7090701@cam.ac.uk>
Date: Wed, 28 Jul 2010 19:32:00 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100726 Thunderbird/3.1.1
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-iio@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: mmotm 2010-07-27-14-56 uploaded (staging/iio)
References: <201007272226.o6RMQRBm008735@imap1.linux-foundation.org> <20100728085428.1e50a262.randy.dunlap@oracle.com>
In-Reply-To: <20100728085428.1e50a262.randy.dunlap@oracle.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks,

Sorry, my bad, will send fix out shortly.

Jonathan
> On Tue, 27 Jul 2010 14:56:50 -0700 akpm@linux-foundation.org wrote:
> 
>> The mm-of-the-moment snapshot 2010-07-27-14-56 has been uploaded to
>>
>>    http://userweb.kernel.org/~akpm/mmotm/
>>
>> and will soon be available at
>>
>>    git://zen-kernel.org/kernel/mmotm.git
> 
> 
> (from linux-next.patch ?)
> 
> In file included from drivers/staging/iio/accel/lis3l02dq_core.c:31:
> drivers/staging/iio/accel/../ring_sw.h:223: warning: 'struct iio_ring_access_funcs' declared inside parameter list
> drivers/staging/iio/accel/../ring_sw.h:223: warning: its scope is only this definition or declaration, which is probably not what you want
> In file included from drivers/staging/iio/accel/lis3l02dq_core.c:35:
> drivers/staging/iio/accel/lis3l02dq.h:161: error: field 'help' has incomplete type
> drivers/staging/iio/accel/lis3l02dq_core.c: In function 'lis3l02dq_spi_read_reg_8':
> drivers/staging/iio/accel/lis3l02dq_core.c:54: warning: type defaults to 'int' in declaration of '__mptr'
> drivers/staging/iio/accel/lis3l02dq_core.c:54: warning: initialization from incompatible pointer type
> drivers/staging/iio/accel/lis3l02dq_core.c: In function 'lis3l02dq_spi_write_reg_8':
> drivers/staging/iio/accel/lis3l02dq_core.c:92: warning: type defaults to 'int' in declaration of '__mptr'
> drivers/staging/iio/accel/lis3l02dq_core.c:92: warning: initialization from incompatible pointer type
> drivers/staging/iio/accel/lis3l02dq_core.c: In function 'lis3l02dq_spi_write_reg_s16':
> drivers/staging/iio/accel/lis3l02dq_core.c:128: warning: type defaults to 'int' in declaration of '__mptr'
> drivers/staging/iio/accel/lis3l02dq_core.c:128: warning: initialization from incompatible pointer type
> drivers/staging/iio/accel/lis3l02dq_core.c: In function 'lis3l02dq_spi_read_reg_s16':
> drivers/staging/iio/accel/lis3l02dq_core.c:172: warning: type defaults to 'int' in declaration of '__mptr'
> drivers/staging/iio/accel/lis3l02dq_core.c:172: warning: initialization from incompatible pointer type
> drivers/staging/iio/accel/lis3l02dq_core.c: In function 'lis3l02dq_thresh_handler_th':
> drivers/staging/iio/accel/lis3l02dq_core.c:615: warning: type defaults to 'int' in declaration of '__mptr'
> drivers/staging/iio/accel/lis3l02dq_core.c:615: warning: initialization from incompatible pointer type
> drivers/staging/iio/accel/lis3l02dq_core.c:618: error: dereferencing pointer to incomplete type
> drivers/staging/iio/accel/lis3l02dq_core.c: In function 'lis3l02dq_stop_device':
> drivers/staging/iio/accel/lis3l02dq_core.c:865: warning: type defaults to 'int' in declaration of '__mptr'
> drivers/staging/iio/accel/lis3l02dq_core.c:865: warning: initialization from incompatible pointer type
> drivers/staging/iio/imu/adis16350_core.c: In function 'adis16350_probe':
> drivers/staging/iio/imu/adis16350_core.c:614: error: implicit declaration of function 'adis16350_configure_ring'
> drivers/staging/iio/imu/adis16350_core.c:657: error: implicit declaration of function 'adis16350_unconfigure_ring'
> 
> 
> config attached.
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

