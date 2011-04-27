Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973Ab1D0PQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:16:00 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:33349 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab1D0PP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:15:59 -0400
Date: Wed, 27 Apr 2011 08:15:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Oren Weil <oren.jer.weil@intel.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, david@woodhou.se
Subject: Re: [PATCH 6/8] staging/mei: Header file contain the Userland API,
 (IOCTL and its struct)
Message-Id: <20110427081541.80cc591a.randy.dunlap@oracle.com>
In-Reply-To: <1303900057-21694-7-git-send-email-oren.jer.weil@intel.com>
References: <1303900057-21694-1-git-send-email-oren.jer.weil@intel.com>
	<1303900057-21694-7-git-send-email-oren.jer.weil@intel.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DB8332A.0089:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011 13:27:35 +0300 Oren Weil wrote:


> +/*
> + * This IOCTL is used to associate the current file descriptor with a
> + * FW Client (given by UUID). This opens a communication channel
> + * between a host client and a FW client. From this point every read and write
> + * will communicate with the associated FW client.
> + * Only in close() (file_operation release()) the communication between
> + * the clients is disconnected
> + *
> + * The IOCTL argument is a struct with a union the contains
> + * the input parameter and the output parameter for this IOCTL.
> + *
> + * The input parameter is UUID of the FW Client.
> + * The output parameter is the properties of the FW client
> + * (FW protocol version and max message size).
> + *
> + */
> +#define IOCTL_MEI_CONNECT_CLIENT \
> +	_IOWR('H' , 0x01, struct mei_connect_client_data)


Please update Documentation/ioctl/ioctl-number.txt.

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
