Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab1CNGwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 02:52:06 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54532 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab1CNGwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 02:52:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=prEX+To+Sx8zPRQEOe7oLF2egUT2GryuGUbZ4DTBycgWM/05Djg2M/WsB7Xd10+6sf
         8SKLeRXf382cMQYJ0ZJkBefLA6a/qRLLYA9vxM/SXt6GN0pxHAgzajmjAYToIpo9IN7w
         Ztf9hvdjZdj4NnbfDg/5kLxmxiSr9OT5JdnXc=
Message-ID: <4D7DBB11.1010802@pobox.com>
Date: Mon, 14 Mar 2011 02:52:01 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Seth Heasley <seth.heasley@intel.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.37.3] ahci: AHCI mode SATA patch for Intel Patsburg
 SATA RAID controller
References: <201103111157.42656.seth.heasley@intel.com>
In-Reply-To: <201103111157.42656.seth.heasley@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 02:57 PM, Seth Heasley wrote:
> This patch adds an updated SATA RAID DeviceID for the Intel Patsburg PCH.
>
> Signed-off-by: Seth Heasley<seth.heasley@intel.com>

applied


