Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab0CRLck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 07:32:40 -0400
Received: from adelie.canonical.com ([91.189.90.139]:54965 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab0CRLcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 07:32:39 -0400
Subject: Patch inclusion in stable
From: Surbhi Palande <Surbhi.Palande@canonical.com>
Reply-To: Surbhi.Palande@canonical.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: stable@kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Canonical Pvt. Ltd.
Date: Thu, 18 Mar 2010 13:32:33 +0200
Message-ID: <1268911953.4382.23.camel@subu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I had a look at the 2.6.32.10 stable patches. Had a comment on the 31st
patch in the series:

commit 7ef79e1045213953b87f45cf5993cc9c70c873ec
Author: Stanislaw Gruszka <sgruszka@redhat.com>

    airo: fix setting zero length WEP key

The linux-2.6 source has another patch that adds the following line:
if (WARN_ON(keylen == 0))
>> +     return -1;

This is added through the commit
6510b8917948283005a125c8337d3312a8a0561c. This commit is missing in the
2.6.32.10 stable patches. I think it should be a part of stable patches
too.

Thanks!

Warm Regards,
Surbhi.



