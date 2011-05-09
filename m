Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab1EIVwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:52:01 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47654
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755052Ab1EIVow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 103/206] Staging: hv: Rename all static functions in ring_buffer.c
Date: Mon,  9 May 2011 14:56:25 -0700
Message-Id: <1304978288-22999-103-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject line says it all.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/ring_buffer.c |   88 +++++++++++++++++++-------------------
 1 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/hv/ring_buffer.c b/drivers/staging/hv/ring_buffer.c
index 7fbadb1..f4707f8 100644
--- a/drivers/staging/hv/ring_buffer.c
+++ b/drivers/staging/hv/ring_buffer.c
@@ -38,7 +38,7 @@
 /*++
 
 Name:
-	get_ringbuffer_availbytes()
+	hv_get_ringbuffer_availbytes()
 
 Description:
 	Get number of bytes available to read and to write to
@@ -46,7 +46,7 @@ Description:
 
 --*/
 static inline void
-get_ringbuffer_availbytes(struct hv_ring_buffer_info *rbi,
+hv_get_ringbuffer_availbytes(struct hv_ring_buffer_info *rbi,
 			  u32 *read, u32 *write)
 {
 	u32 read_loc, write_loc;
@@ -62,14 +62,14 @@ get_ringbuffer_availbytes(struct hv_ring_buffer_info *rbi,
 /*++
 
 Name:
-	get_next_write_location()
+	hv_get_next_write_location()
 
 Description:
 	Get the next write location for the specified ring buffer
 
 --*/
 static inline u32
-get_next_write_location(struct hv_ring_buffer_info *ring_info)
+hv_get_next_write_location(struct hv_ring_buffer_info *ring_info)
 {
 	u32 next = ring_info->ring_buffer->write_index;
 
@@ -81,14 +81,14 @@ get_next_write_location(struct hv_ring_buffer_info *ring_info)
 /*++
 
 Name:
-	set_next_write_location()
+	hv_set_next_write_location()
 
 Description:
 	Set the next write location for the specified ring buffer
 
 --*/
 static inline void
-set_next_write_location(struct hv_ring_buffer_info *ring_info,
+hv_set_next_write_location(struct hv_ring_buffer_info *ring_info,
 		     u32 next_write_location)
 {
 	ring_info->ring_buffer->write_index = next_write_location;
@@ -97,14 +97,14 @@ set_next_write_location(struct hv_ring_buffer_info *ring_info,
 /*++
 
 Name:
-	get_next_read_location()
+	hv_get_next_read_location()
 
 Description:
 	Get the next read location for the specified ring buffer
 
 --*/
 static inline u32
-get_next_read_location(struct hv_ring_buffer_info *ring_info)
+hv_get_next_read_location(struct hv_ring_buffer_info *ring_info)
 {
 	u32 next = ring_info->ring_buffer->read_index;
 
@@ -116,7 +116,7 @@ get_next_read_location(struct hv_ring_buffer_info *ring_info)
 /*++
 
 Name:
-	get_next_readlocation_withoffset()
+	hv_get_next_readlocation_withoffset()
 
 Description:
 	Get the next read location + offset for the specified ring buffer.
@@ -124,7 +124,7 @@ Description:
 
 --*/
 static inline u32
-get_next_readlocation_withoffset(struct hv_ring_buffer_info *ring_info,
+hv_get_next_readlocation_withoffset(struct hv_ring_buffer_info *ring_info,
 				 u32 offset)
 {
 	u32 next = ring_info->ring_buffer->read_index;
@@ -139,14 +139,14 @@ get_next_readlocation_withoffset(struct hv_ring_buffer_info *ring_info,
 /*++
 
 Name:
-	set_next_read_location()
+	hv_set_next_read_location()
 
 Description:
 	Set the next read location for the specified ring buffer
 
 --*/
 static inline void
-set_next_read_location(struct hv_ring_buffer_info *ring_info,
+hv_set_next_read_location(struct hv_ring_buffer_info *ring_info,
 		    u32 next_read_location)
 {
 	ring_info->ring_buffer->read_index = next_read_location;
@@ -156,14 +156,14 @@ set_next_read_location(struct hv_ring_buffer_info *ring_info,
 /*++
 
 Name:
-	get_ring_buffer()
+	hv_get_ring_buffer()
 
 Description:
 	Get the start of the ring buffer
 
 --*/
 static inline void *
-get_ring_buffer(struct hv_ring_buffer_info *ring_info)
+hv_get_ring_buffer(struct hv_ring_buffer_info *ring_info)
 {
 	return (void *)ring_info->ring_buffer->buffer;
 }
@@ -172,14 +172,14 @@ get_ring_buffer(struct hv_ring_buffer_info *ring_info)
 /*++
 
 Name:
-	get_ring_buffersize()
+	hv_get_ring_buffersize()
 
 Description:
 	Get the size of the ring buffer
 
 --*/
 static inline u32
-get_ring_buffersize(struct hv_ring_buffer_info *ring_info)
+hv_get_ring_buffersize(struct hv_ring_buffer_info *ring_info)
 {
 	return ring_info->ring_datasize;
 }
@@ -187,14 +187,14 @@ get_ring_buffersize(struct hv_ring_buffer_info *ring_info)
 /*++
 
 Name:
-	get_ring_bufferindices()
+	hv_get_ring_bufferindices()
 
 Description:
 	Get the read and write indices as u64 of the specified ring buffer
 
 --*/
 static inline u64
-get_ring_bufferindices(struct hv_ring_buffer_info *ring_info)
+hv_get_ring_bufferindices(struct hv_ring_buffer_info *ring_info)
 {
 	return (u64)ring_info->ring_buffer->write_index << 32;
 }
@@ -214,7 +214,7 @@ void hv_dump_ring_info(struct hv_ring_buffer_info *ring_info, char *prefix)
 	u32 bytes_avail_towrite;
 	u32 bytes_avail_toread;
 
-	get_ringbuffer_availbytes(ring_info,
+	hv_get_ringbuffer_availbytes(ring_info,
 	&bytes_avail_toread,
 	&bytes_avail_towrite);
 
@@ -235,14 +235,14 @@ void hv_dump_ring_info(struct hv_ring_buffer_info *ring_info, char *prefix)
 /* Internal routines */
 
 static u32
-copyto_ringbuffer(
+hv_copyto_ringbuffer(
 	struct hv_ring_buffer_info	*ring_info,
 	u32				start_write_offset,
 	void				*src,
 	u32				srclen);
 
 static u32
-copyfrom_ringbuffer(
+hv_copyfrom_ringbuffer(
 	struct hv_ring_buffer_info	*ring_info,
 	void				*dest,
 	u32				destlen,
@@ -266,7 +266,7 @@ void hv_ringbuffer_get_debuginfo(struct hv_ring_buffer_info *ring_info,
 	u32 bytes_avail_toread;
 
 	if (ring_info->ring_buffer) {
-		get_ringbuffer_availbytes(ring_info,
+		hv_get_ringbuffer_availbytes(ring_info,
 					&bytes_avail_toread,
 					&bytes_avail_towrite);
 
@@ -369,7 +369,7 @@ int hv_ringbuffer_write(struct hv_ring_buffer_info *outring_info,
 
 	spin_lock_irqsave(&outring_info->ring_lock, flags);
 
-	get_ringbuffer_availbytes(outring_info,
+	hv_get_ringbuffer_availbytes(outring_info,
 				&bytes_avail_toread,
 				&bytes_avail_towrite);
 
@@ -384,20 +384,20 @@ int hv_ringbuffer_write(struct hv_ring_buffer_info *outring_info,
 	}
 
 	/* Write to the ring buffer */
-	next_write_location = get_next_write_location(outring_info);
+	next_write_location = hv_get_next_write_location(outring_info);
 
 	for_each_sg(sglist, sg, sgcount, i)
 	{
-		next_write_location = copyto_ringbuffer(outring_info,
+		next_write_location = hv_copyto_ringbuffer(outring_info,
 						     next_write_location,
 						     sg_virt(sg),
 						     sg->length);
 	}
 
 	/* Set previous packet start */
-	prev_indices = get_ring_bufferindices(outring_info);
+	prev_indices = hv_get_ring_bufferindices(outring_info);
 
-	next_write_location = copyto_ringbuffer(outring_info,
+	next_write_location = hv_copyto_ringbuffer(outring_info,
 					     next_write_location,
 					     &prev_indices,
 					     sizeof(u64));
@@ -406,7 +406,7 @@ int hv_ringbuffer_write(struct hv_ring_buffer_info *outring_info,
 	mb();
 
 	/* Now, update the write location */
-	set_next_write_location(outring_info, next_write_location);
+	hv_set_next_write_location(outring_info, next_write_location);
 
 	/* Dumpring_info(Outring_info, "AFTER "); */
 
@@ -434,7 +434,7 @@ int hv_ringbuffer_peek(struct hv_ring_buffer_info *Inring_info,
 
 	spin_lock_irqsave(&Inring_info->ring_lock, flags);
 
-	get_ringbuffer_availbytes(Inring_info,
+	hv_get_ringbuffer_availbytes(Inring_info,
 				&bytes_avail_toread,
 				&bytes_avail_towrite);
 
@@ -452,9 +452,9 @@ int hv_ringbuffer_peek(struct hv_ring_buffer_info *Inring_info,
 	}
 
 	/* Convert to byte offset */
-	next_read_location = get_next_read_location(Inring_info);
+	next_read_location = hv_get_next_read_location(Inring_info);
 
-	next_read_location = copyfrom_ringbuffer(Inring_info,
+	next_read_location = hv_copyfrom_ringbuffer(Inring_info,
 						Buffer,
 						buflen,
 						next_read_location);
@@ -488,7 +488,7 @@ int hv_ringbuffer_read(struct hv_ring_buffer_info *inring_info, void *buffer,
 
 	spin_lock_irqsave(&inring_info->ring_lock, flags);
 
-	get_ringbuffer_availbytes(inring_info,
+	hv_get_ringbuffer_availbytes(inring_info,
 				&bytes_avail_toread,
 				&bytes_avail_towrite);
 
@@ -502,14 +502,14 @@ int hv_ringbuffer_read(struct hv_ring_buffer_info *inring_info, void *buffer,
 	}
 
 	next_read_location =
-		get_next_readlocation_withoffset(inring_info, offset);
+		hv_get_next_readlocation_withoffset(inring_info, offset);
 
-	next_read_location = copyfrom_ringbuffer(inring_info,
+	next_read_location = hv_copyfrom_ringbuffer(inring_info,
 						buffer,
 						buflen,
 						next_read_location);
 
-	next_read_location = copyfrom_ringbuffer(inring_info,
+	next_read_location = hv_copyfrom_ringbuffer(inring_info,
 						&prev_indices,
 						sizeof(u64),
 						next_read_location);
@@ -520,7 +520,7 @@ int hv_ringbuffer_read(struct hv_ring_buffer_info *inring_info, void *buffer,
 	mb();
 
 	/* Update the read index */
-	set_next_read_location(inring_info, next_read_location);
+	hv_set_next_read_location(inring_info, next_read_location);
 
 	/* Dumpring_info(Inring_info, "AFTER "); */
 
@@ -533,7 +533,7 @@ int hv_ringbuffer_read(struct hv_ring_buffer_info *inring_info, void *buffer,
 /*++
 
 Name:
-	copyto_ringbuffer()
+	hv_copyto_ringbuffer()
 
 Description:
 	Helper routine to copy from source to ring buffer.
@@ -541,14 +541,14 @@ Description:
 
 --*/
 static u32
-copyto_ringbuffer(
+hv_copyto_ringbuffer(
 	struct hv_ring_buffer_info	*ring_info,
 	u32				start_write_offset,
 	void				*src,
 	u32				srclen)
 {
-	void *ring_buffer = get_ring_buffer(ring_info);
-	u32 ring_buffer_size = get_ring_buffersize(ring_info);
+	void *ring_buffer = hv_get_ring_buffer(ring_info);
+	u32 ring_buffer_size = hv_get_ring_buffersize(ring_info);
 	u32 frag_len;
 
 	/* wrap-around detected! */
@@ -569,7 +569,7 @@ copyto_ringbuffer(
 /*++
 
 Name:
-	copyfrom_ringbuffer()
+	hv_copyfrom_ringbuffer()
 
 Description:
 	Helper routine to copy to source from ring buffer.
@@ -577,14 +577,14 @@ Description:
 
 --*/
 static u32
-copyfrom_ringbuffer(
+hv_copyfrom_ringbuffer(
 	struct hv_ring_buffer_info	*ring_info,
 	void				*dest,
 	u32				destlen,
 	u32				start_read_offset)
 {
-	void *ring_buffer = get_ring_buffer(ring_info);
-	u32 ring_buffer_size = get_ring_buffersize(ring_info);
+	void *ring_buffer = hv_get_ring_buffer(ring_info);
+	u32 ring_buffer_size = hv_get_ring_buffersize(ring_info);
 
 	u32 frag_len;
 
-- 
1.7.4.1

