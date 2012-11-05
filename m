Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab2KEHqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 02:46:33 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43475 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2KEHqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 02:46:32 -0500
MIME-Version: 1.0
In-Reply-To: <20121105074149.GA1947@kroah.com>
References: <20121102170247.406319110@linuxfoundation.org>
	<CAEH94LhVHXEEk0XzL3z_EyUDpRMeP02MTUGBxzV5=oOxWGDu3g@mail.gmail.com>
	<20121105074149.GA1947@kroah.com>
Date: Mon, 5 Nov 2012 15:46:31 +0800
Message-ID: <CAEH94Li35RG4RtCDF400xq-PTGTh4E+2AJCA30C5KVVpoDGY7A@mail.gmail.com>
Subject: Re: [ 00/24] 3.6.6-stable review
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>, bernhard.kohl@nsn.com,
        herton.krzesinski@canonical.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 3:41 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Nov 05, 2012 at 03:37:31PM +0800, Zhi Yong Wu wrote:
>> HI, greg
>>
>> Some of the patchset haven't passed the check of checkpatch.pl as below:
>>
>> WARNING: line over 80 characters
>> #85: FILE: drivers/block/floppy.c:4319:
>> +                     device_remove_file(&floppy_device[drive].dev, &dev_attr_cmos);
>>
>> WARNING: line over 80 characters
>> #419: FILE: drivers/scsi/qla2xxx/qla_target.c:744:
>> +                     ha->tgt.tgt_ops->update_sess(sess, fcport->d_id, fcport->loop_id,
>>
>> WARNING: line over 80 characters
>> #420: FILE: drivers/scsi/qla2xxx/qla_target.c:745:
>> +                                             (fcport->flags & FCF_CONF_COMP_SUPPORTED));
>>
>> WARNING: line over 80 characters
>> #443: FILE: drivers/scsi/qla2xxx/qla_target.c:871:
>> +             ha->tgt.tgt_ops->update_sess(sess, fcport->d_id, fcport->loop_id,
>>
>> WARNING: line over 80 characters
>> #444: FILE: drivers/scsi/qla2xxx/qla_target.c:872:
>> +                                     (fcport->flags & FCF_CONF_COMP_SUPPORTED));
>>
>> WARNING: line over 80 characters
>> #488: FILE: drivers/scsi/qla2xxx/tcm_qla2xxx.c:1491:
>> +                     sess->s_id.b.domain, sess->s_id.b.area, sess->s_id.b.al_pa,
>>
>> WARNING: line over 80 characters
>> #514: FILE: drivers/scsi/qla2xxx/tcm_qla2xxx.c:1517:
>> +                     WARN(btree_remove32(&lport->lport_fcport_map, key) != se_nacl,
>>
>> WARNING: line over 80 characters
>> #516: FILE: drivers/scsi/qla2xxx/tcm_qla2xxx.c:1519:
>> +                          sess->s_id.b.domain, sess->s_id.b.area, sess->s_id.b.al_pa);
>>
>> WARNING: line over 80 characters
>> #519: FILE: drivers/scsi/qla2xxx/tcm_qla2xxx.c:1522:
>> +                          sess->s_id.b.domain, sess->s_id.b.area, sess->s_id.b.al_pa);
>>
>> WARNING: line over 80 characters
>> #530: FILE: drivers/scsi/qla2xxx/tcm_qla2xxx.c:1533:
>> +                     btree_insert32(&lport->lport_fcport_map, key, se_nacl, GFP_ATOMIC);
>>
>> total: 0 errors, 10 warnings, 1094 lines checked
>
> That's fine, take those up with the people who send them in for the
> upstream kernel, I take them no-changes for the stable releases.
I will do after all three stable -rc kernels test are completed.

>
> And really, the 80 characters is just a "hint", it's not a hard and fast
> rule for anything here.  Especially for the old, and horrible, floppy
> and scsi drivers :)
ok, thanks.

>
> thanks,
>
> greg k-h



-- 
Regards,

Zhi Yong Wu
