Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab2F0Hxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 03:53:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55160 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357Ab2F0Hxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 03:53:42 -0400
Message-ID: <4FEABBFC.6090708@canonical.com>
Date: Wed, 27 Jun 2012 15:53:32 +0800
From: Alex Hung <alex.hung@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>, corentincj@iksaif.net,
        mjg@redhat.com, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asus-wmi: use ASUS_WMI_METHODID_DSTS2 as default DSTS
 ID.
References: <1340164055-1062-1-git-send-email-alex.hung@canonical.com> <20120626213958.GA17871@burratino> <20120626215806.GM21479@carsten-otto>
In-Reply-To: <20120626215806.GM21479@carsten-otto>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2012 05:58 AM, Carsten Otto wrote:
> Dear all,
>
> On Tue, Jun 26, 2012 at 04:39:58PM -0500, Jonathan Nieder wrote:
>> After applying the patch described above to 3.2.21, multimedia keys
>> work.
>
> To be precise, only some of the Fn keys work. I will update the
> bug report at http://bugs.debian.org/679158 now. Please contact me if
> you need further information,
>
> Best regards,

Some Fn keys fail to work is probably the result of un-handled events, 
i.e. asus_wmi: Unknown key 7a pressed.

Do you always receive the error messages for each of the Fn-keys that 
fails? I can take a closer look and try to fix each of them. I don't 
have a Asus Zenbook Prime but I can check on other available Asus machines.

Best Regards,
Alex Hung
