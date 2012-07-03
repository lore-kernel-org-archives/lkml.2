Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab2GCGpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 02:45:47 -0400
Received: from goliath.siemens.de ([192.35.17.28]:22369 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab2GCGpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 02:45:46 -0400
Message-ID: <4FF29509.3030909@siemens.com>
Date: Tue, 03 Jul 2012 08:45:29 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 5/6 v5] deal with guest panicked event accoring to -onpanic
 parameter
References: <4FEAAE6E.7070302@cn.fujitsu.com> <4FEAAFFF.40401@cn.fujitsu.com> <4FEB1B06.4050309@siemens.com> <4FEBB044.1000306@cn.fujitsu.com> <4FEC153B.6040300@siemens.com> <4FF28C17.703@cn.fujitsu.com> <4FF292D5.20403@siemens.com> <4FF29482.6050206@cn.fujitsu.com>
In-Reply-To: <4FF29482.6050206@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-03 08:43, Wen Congyang wrote:
>> I'm not talking about changing the interface to the guest, I'm talking
>> about how to model it in QEMU. And that difference would be transparent
>> to the guest. I pointed you to examples like hw/kvm/clock.c.
> 
> OK, I will read the code in hw/kvm/clock.c

Just to avoid confusion: That example is just good for a trivial
framework. It does vmstate saving, something you don't need as your
"device" is stateless. If you want to find out how to register PIO
ranges, also check e.g. hw/pcspk.c.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SDP-DE
Corporate Competence Center Embedded Linux


