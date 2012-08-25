Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab2HYI0z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 04:26:55 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37182 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab2HYI0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 04:26:50 -0400
Message-ID: <50388C45.6030707@gmail.com>
Date: Sat, 25 Aug 2012 10:26:45 +0200
From: Bernhard Froemel <bfroemel@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
CC: linux-kernel@vger.kernel.org, froemel@vmars.tuwien.ac.at
Subject: [PATCH v2 0/2] apple-gmux: Fixes related to 'Support for new hardware'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

it follows a refined version where thanks to Seth and his extensive x86
assembly knowledge my initial assumption about how Apple does byte
writes could be falsified. It appears that byte writes only failed
because the index protocol was not correctly followed in the read functions.

Cheers,
 Bernhard
