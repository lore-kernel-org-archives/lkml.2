Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744Ab2ITQrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 12:47:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:40060 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab2ITQrk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 12:47:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,454,1344236400"; 
   d="scan'208";a="147232133"
From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        infinipath <infinipath@intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH 25/25] userns: Convert ipathfs to use GLOBAL_ROOT_UID
 and GLOBAL_ROOT_GID
Thread-Topic: [PATCH 25/25] userns: Convert ipathfs to use GLOBAL_ROOT_UID
 and GLOBAL_ROOT_GID
Thread-Index: AQHNlykaAdCZrx+hJkeA2ouVbRQr7peTZBHg
Date: Thu, 20 Sep 2012 16:47:37 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC0D50588F@FMSMSX108.amr.corp.intel.com>
References: <877grox6ql.fsf@xmission.com>
 <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
 <1348141326-23355-25-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1348141326-23355-25-git-send-email-ebiederm@xmission.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: [PATCH 25/25] userns: Convert ipathfs to use GLOBAL_ROOT_UID and
> GLOBAL_ROOT_GID
> 
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Cc: Mike Marciniszyn <infinipath@intel.com>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Thanks for the patch!

Acked-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
