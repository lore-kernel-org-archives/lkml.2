Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab0HSN7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 09:59:08 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47928 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab0HSN7G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 09:59:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=O4hF6ztV/LtO5RlE2oFupl5zV1Wdbp93E26lvtcCyPr4iOknBwKl9+oWFvjnZdXa/V
         6DIrBwgUcRUSGShH9BCHaNgi07OLiHLiyRUKApEwcuChPTD7lD+id2QVrQL91x4da1AR
         /7wnFWjy4P2O8kTvZWkDMLb05ZGQCyEEBmWdM=
MIME-Version: 1.0
Date: Thu, 19 Aug 2010 10:59:04 -0300
Message-ID: <AANLkTikEMfVE0FaT_se5H1yq7FOKi0gu8qbRMB0c8JKJ@mail.gmail.com>
Subject: Using block layer's I/O context api (block/blk-ioc.c) without CFQ.
From: =?ISO-8859-1?Q?Pedro_Eug=EAnio_Rocha?= 
	<pedro.eugenio.rocha@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is there a way to use the generic block layer I/O context api
(block/blk-ioc.c), without
using cfq specific functions and structs? I'm writing an I/O scheduler
for my master
thesis, and I'd like to use my own functions for I/O context handling,
not cfq's. Sorry
if I'm missing something here.

Thanks,

Pedro Eugênio Rocha
