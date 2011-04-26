Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab1DZFt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 01:49:28 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:54372 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab1DZFt1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 01:49:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=aNTZuL82vYAPHDtF5yRi6Fqnxq88Wyd2OEhnG3nOh5qTSAAoYsg++Ztkn0vmyZfaAb
         H5eCNTWR6B7AZW9SZgN8XyDW/vq90LYAOWpANw849FvXCpr4OV8vOOrdnO5bgHva+mMo
         2vS3lMb+N64Lb4TWgV97rHMIEuStheBc/P9Ys=
MIME-Version: 1.0
Date: Tue, 26 Apr 2011 13:49:25 +0800
Message-ID: <BANLkTin8mE=DLWma=U+CdJaQW03X2M2W1w@mail.gmail.com>
Subject: readahead and oom
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When memory pressure is high, readahead could cause oom killing.
IMHO we should stop readaheading under such circumstances。If it's true
how to fix it?

-- 
Regards
dave
