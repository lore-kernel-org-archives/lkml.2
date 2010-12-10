Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab0LJKQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 05:16:59 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:55611 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab0LJKQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 05:16:57 -0500
Subject: Re: [RFC PATCH V2 0/5] macvtap TX zero copy between guest and host
 kernel
From: Shirley Ma <mashirle@us.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, mst@redhat.com, xiaohui.xin@intel.com,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1291974691.2167.24.camel@localhost.localdomain>
References: <1291974691.2167.24.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 02:16:50 -0800
Message-ID: <1291976210.2167.52.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch has built and tested against most recent linus git tree. But
I haven't done checkpatch yet. I would like to know whether this
approach is acceptable or not first.

Thanks
Shirley

