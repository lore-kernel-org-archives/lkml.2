Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab1EEMeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 08:34:05 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63104 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab1EEMeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 08:34:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=A3dgpuEQP++HOeWn6C38HwL9YEi0MxtG/2h/f/GDNujyOTiE/Yo3wXG1dJ8BngO//L
         paYR03xUGZePRDmQP/7Dy7YRLmxoEOMaWmO99BJjP61lI+I3ubNqpxm64HX9/1C8gCEg
         nWDbkjtiPXaG2FMnMciVUa52Mp8YlZEHkxVoA=
Message-ID: <4DC29922.6050406@pobox.com>
Date: Thu, 05 May 2011 08:33:38 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: shaohua.li@intel.com
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        jaxboe@fusionio.com, htejun@gmail.com, hch@infradead.org,
        djwong@us.ibm.com, sshtylyov@mvista.com
Subject: Re: [patch v3 3/3] SATA: enable non-queueable flush flag
References: <20110505015932.306763905@sli10-conroe.sh.intel.com> <20110505020417.986492128@sli10-conroe.sh.intel.com>
In-Reply-To: <20110505020417.986492128@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2011 09:59 PM, shaohua.li@intel.com wrote:
> Enable non-queueable flush flag for SATA.
>
> Signed-off-by: Shaohua Li<shaohua.li@intel.com>

Acked-by: Jeff Garzik <jgarzik@redhat.com>

This SATA patch should go into the block tree alongside patches 1 & 2.


