Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab1JMHfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 03:35:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49640 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab1JMHfd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 03:35:33 -0400
MIME-Version: 1.0
In-Reply-To: <87vcrtqyc3.fsf@devron.myhome.or.jp>
References: <CAKYAXd9v_wFg2RQ_R+fYyCJnCbnuMs_VECujOen1GUSGXo3rHw@mail.gmail.com>
	<87vcrtqyc3.fsf@devron.myhome.or.jp>
Date: Thu, 13 Oct 2011 16:35:29 +0900
Message-ID: <CAKYAXd-qmJSbGNCNBjtahL+OtQDkOrnop3MzHRYRVR2anu0fGw@mail.gmail.com>
Subject: Re: RFC : fat : default errors use FAT_ERRORS_CONT instead of FAT_ERRORS_RO.
From: NamJae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/13 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> NamJae Jeon <linkinjeon@gmail.com> writes:
>
>> Hi ogawa.
>>
>> I found different error exception between linux fat and windows fat.
>>
>> When fat is currputed by sudden unplug usb device formatted fat, fat
>> does never change RO partition on windows.
>>
>> It said windows fat provide a chance that continuously access
>> partition except corrupted file.
>>
>> Currently when access corrupted file, linux fat change RO parition
>> from RW. So user no longer do open/write on linux fat.
>>
>> I suggest that the default errors of linux fat use FAT_ERRORS_CONT
>> instead of FAT_ERRORS_RO.
>>
>> I want to know your opinion.
>
> I think it is dangerous, and the default should be safer side.
>
> If driver noticed the corruption, it means FS is not unknown state
> anymore.  Any files/directories are possibly corrupted.
>
> Even if you change the file that seems to be uncorrupted, it may make FS
> unrecoverable more. (e.g. lose all data in worst case)
Hi ogawa.
Thanks for your reply. I follow your opinion.

>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
