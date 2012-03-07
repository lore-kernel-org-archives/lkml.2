Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab2CGKIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 05:08:10 -0500
Received: from tundra.namei.org ([65.99.196.166]:57182 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab2CGKIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 05:08:09 -0500
Date: Wed, 7 Mar 2012 21:08:05 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: Re: [PATCH v2 00/11] ima: appraisal extension
In-Reply-To: <1330629048-5933-1-git-send-email-zohar@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.02.1203072057350.29863@tundra.namei.org>
References: <1330629048-5933-1-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2012, Mimi Zohar wrote:

> IMA currently maintains an integrity measurement list used to assert the
> integrity of the running system to a third party.  The IMA-appraisal
> extension adds local integrity validation and enforcement of the
> measurement against a "good" value stored as an extended attribute
> 'security.ima'. 

Do you know if any distros are planning on integrating EVM/IMA?

What about Tizen ?  The now defunct MeeGo project weas previously the 
main intended user.




- James
-- 
James Morris
<jmorris@namei.org>
