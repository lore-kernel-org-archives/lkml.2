Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab0LURwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 12:52:53 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43366 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab0LURwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 12:52:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=I31B91XXmIg63r0OxNgMee2oD74MoSI5rc0yBkHe/IDm/iNXlaI6qMlk195aZzD1Lf
         G0Ezt3h4gmlgYXGmtR3p/7YabvquLIn+NAD/AU7tt9KNGC35VmFxTXIvswIVWEJ/Kqd7
         Ezq8mmFc0ojm2gFrdQnlZTBxDnmskAGL9nYaE=
Message-ID: <4D10E96F.6070406@gmail.com>
Date: Tue, 21 Dec 2010 09:52:47 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        sodaville@linutronix.de, linuxppc-dev@lists.ozlabs.org,
        microblaze-uclinux@itee.uq.edu.au, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/4] of: Add support for linking device tree blobs into
 vmlinux
References: <cover.1291820033.git.dirk.brandewie@gmail.com> <99ff131ecbee621f0d3178d6d3896d6f39207d6f.1291820034.git.dirk.brandewie@gmail.com> <4D10B8AA.3070500@suse.cz>
In-Reply-To: <4D10B8AA.3070500@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2010 06:24 AM, Michal Marek wrote:
> On 8.12.2010 16:01, dirk.brandewie@gmail.com wrote:
>> +quiet_cmd_dt_S_dtb= DTB    $@
>
>> +quiet_cmd_dtc = DTC $@
>
> Hi,
>
> just an aesthetic remark: The target name should start at the 9th
> column, so there should be 5 spaces after both "DTB" and "DTC".
>
> Michal
Thanks I will fix this.

--Dirk

