Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207Ab0DHTQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:16:12 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59864 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933132Ab0DHTQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:16:08 -0400
Message-ID: <4BBE2B66.8090900@cs.wisc.edu>
Date: Thu, 08 Apr 2010 14:15:50 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: open-iscsi@googlegroups.com
CC: Rakesh Ranjan <rakesh@chelsio.com>, netdev@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       kxie@chelsio.com, davem@davemloft.net,
       James.Bottomley@hansenpartnership.com
Subject: Re: [PATCH 3/3] cxgb4i: iscsi and pdu processing part
References: <1270728855-20951-1-git-send-email-rakesh@chelsio.com> <1270728855-20951-2-git-send-email-rakesh@chelsio.com> <1270728855-20951-3-git-send-email-rakesh@chelsio.com> <1270728855-20951-4-git-send-email-rakesh@chelsio.com>
In-Reply-To: <1270728855-20951-4-git-send-email-rakesh@chelsio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2010 07:14 AM, Rakesh Ranjan wrote:
> From: Rakesh Ranjan<rakesh@chelsio.com>
>
>
> Signed-off-by: Rakesh Ranjan<rakesh@chelsio.com>
> ---
>   drivers/scsi/cxgb4i/cxgb4i_iscsi.c |  715 ++++++++++++++++++++++++++++++++++++
>   drivers/scsi/cxgb4i/cxgb4i_pdu.c   |  475 ++++++++++++++++++++++++
>   drivers/scsi/cxgb4i/cxgb4i_pdu.h   |   61 +++
>   3 files changed, 1251 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/scsi/cxgb4i/cxgb4i_iscsi.c
>   create mode 100644 drivers/scsi/cxgb4i/cxgb4i_pdu.c
>   create mode 100644 drivers/scsi/cxgb4i/cxgb4i_pdu.h
>

The code in these files looks like the code is the cxgb3i iscsi and pdu 
code. Can you just make a common cxgb3i iscsi/pdu layer and add some 
callouts?

Something similar to what qla2xxx or lpfc has done to support multiple 
cards. In their case they have common fc and driver stuff and then 
callouts for hw specifics?
